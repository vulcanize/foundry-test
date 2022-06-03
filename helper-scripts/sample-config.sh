#!/bin/bash
# This "script" is simply a configuration file that will be loaded by other files.
# It allows users to specify where related directories are instead of having to hardcode them.

vulcanize_ops=${vulcanize_repo_base_dir}/ops
vulcanize_stack_orchestrator=${vulcanize_repo_base_dir}/stack-orchestrator
vulcanize_ipld_eth_db=${vulcanize_repo_base_dir}/ipld-eth-db
vulcanize_ipld_ethcl_indexer=${vulcanize_repo_base_dir}/ipld-ethcl-indexer
vulcanize_go_ethereum=${vulcanize_repo_base_dir}/go-ethereum
vulcanize_ipld_eth_server=${vulcanize_repo_base_dir}/ipld-eth-server
vulcanize_ipld_ethcl_db=${vulcanize_repo_base_dir}/ipld-ethcl-db
vulcanize_eth_statediff_fill_service=${vulcanize_repo_base_dir}/eth-statediff-fill-service
vulcanize_test_contract=${vulcanize_repo_base_dir}/ipld-eth-db-validator/test/contract

# USE SINGLE QUOTES ONLY!!!!!!
extra_args='--metrics --metrics.expensive --metrics.addr 0.0.0.0 --metrics.port 6060'
db_write=true
eth_forward_eth_calls=false
eth_proxy_on_error=false
eth_http_path=''

watched_address_gap_filler_enabled=false
watched_address_gap_filler_interval=5

ethcl_capture_mode=boot
ethcl_skip_sync=true
ethcl_known_gap_increment=1000000

# Allow us to use the same configs for v3 and v4 db
ipld_eth_server_db_dependency=access-node
go_ethereum_db_dependency=access-node

connecting_db_name=vulcanize_testing_v4