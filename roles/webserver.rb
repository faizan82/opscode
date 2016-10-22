name "webserver"
description "Nginx webserver"
run_list "recipe[nginx_webserver]"
env_run_lists "dev" => ["recipe[nginx_webserver::config_dev]"], "qa" => ["recipe[nginx_webserver::config_qa]"], "_default" => ["recipe[nginx_webserver]"]
