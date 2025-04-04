STACK_NAME       ?= WordpressStack
RAIN_CMD         ?= ${HOME}/go/bin/rain
PARAMS_FILE      ?= wordpress-dev.json
PARAMS_FILE_PROD ?= wordpress-prod.json

# Verify that rain & jq are installed
checkrain:
	@if [ ! -f $(RAIN_CMD) ]; then \
		echo "Error: rain not found in PATH. Please adjust your PATH, or install rain, to deploy this stack."; \
		exit 1; \
	fi
	@if ! command -v jq &> /dev/null; then \
		echo "Error: jq not found in PATH. Please adjust your PATH, or install jq, to deploy this stack."; \
		exit 1; \
	fi

# Merge templates into a single big file
merged.yaml: checkrain
	$(RAIN_CMD) merge templates/*.yaml -o merged.yaml

# Lint merged template
lint: merged.yaml
	cfn-lint merged.yaml --non-zero-exit-code error

# Deploy (dev)
deploy: lint
	$(RAIN_CMD) deploy merged.yaml $(STACK_NAME) \
		--params $$(jq -r 'map("\(.ParameterKey)=\(.ParameterValue)") | join(",")' $(PARAMS_FILE)) \
		--params CloudFrontPrefixListId=$$(\
			aws ec2 describe-managed-prefix-lists \
			--filters Name=prefix-list-name,Values=com.amazonaws.global.cloudfront.origin-facing \
			--query "PrefixLists[0].PrefixListId" \
			--output text\
		)

# Deploy (prod)
deploy-prod: lint
	$(RAIN_CMD) deploy merged.yaml $(STACK_NAME) \
		--params $$(jq -r 'map("\(.ParameterKey)=\(.ParameterValue)") | join(",")' $(PARAMS_FILE_PROD)) \
		--params CloudFrontPrefixListId=$$(\
			aws ec2 describe-managed-prefix-lists \
			--filters Name=prefix-list-name,Values=com.amazonaws.global.cloudfront.origin-facing \
			--query "PrefixLists[0].PrefixListId" \
			--output text\
		)

delete:
	aws cloudformation delete-stack --stack-name $(STACK_NAME)

clean:
	rm merged.yaml

.PHONY: lint deploy deploy-prod deploy-aws deploy-aws-prod update-aws update-aws-prod delete clean
