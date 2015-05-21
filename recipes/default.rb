execute "gem uninstall puma" do
  only_if "gem list | grep puma"
end

include_recipe "nginx"

directory "/etc/nginx/shared"
directory "/etc/nginx/http"
directory "/etc/nginx/ssl"

node[:deploy].each do |application, deploy|
  puma_config application do
    directory deploy[:deploy_to]
    environment deploy[:rails_env]
    logrotate deploy[:puma] && deploy[:puma][:logrotate] ? deploy[:puma][:logrotate] : true
    thread_min deploy[:puma] && deploy[:puma][:thread_min] ? deploy[:puma][:thread_min] : 1
    thread_max deploy[:puma] && deploy[:puma][:thread_max] ? deploy[:puma][:thread_max] : 16
    workers deploy[:puma] && deploy[:puma][:workers] ? deploy[:puma][:workers] : 2
    worker_timeout deploy[:puma] && deploy[:puma][:worker_timeout] ? deploy[:puma][:worker_timeout] : 30
    restart_timeout deploy[:puma] && deploy[:puma][:restart_timeout] ? deploy[:puma][:restart_timeout] : 120
    exec_prefixdeploy[:puma] && deploy[:puma][:exec_prefix] ? deploy[:puma][:exec_prefix] : 'bundle exec'
    prune_bundler deploy[:puma] && deploy[:puma][:prune_bundler] ? deploy[:puma][:prune_bundler] : true
    preload_app deploy[:puma] && deploy[:puma][:preload_app] ? deploy[:puma][:preload_app] : false
  end
end

