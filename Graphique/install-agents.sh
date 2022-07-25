curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.2.3-darwin-x86_64.tar.gz
tar xzvf elastic-agent-8.2.3-darwin-x86_64.tar.gz
cd elastic-agent-8.2.3-darwin-x86_64
sudo ./elastic-agent install --url=https://162b9dcabf0e448a8bd6471a98c3a980.fleet.us-east-1.aws.found.io:443 --enrollment-token=RXdWWjFJRUJaeVlCcjVSZVdQWVk6RWZGWjMxTkNUUS1aUmstMklEQXZ3dw==
