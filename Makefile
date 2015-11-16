TEST_PILLAR_ROOT := pillar
TEST_LOG_FILE := /dev/null
TEST_CONFIG_DIR := testing/

.PHONY: test

test:
	salt-call --local --pillar-root ${TEST_PILLAR_ROOT} \
		--log-file ${TEST_LOG_FILE} \
		--config-dir=${TEST_CONFIG_DIR} \
		state.show_highstate
