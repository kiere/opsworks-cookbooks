include_recipe 'deploy'
include_recipe "nginx::service"

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'static'
    Chef::Log.debug("Skipping deploy::web application #{application} as it is not an static HTML app")
    next
  end

  opsworks_deploy_dir do
    Chef::Log.info("Denoncourt opsworks_deploy_dir ")
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    Chef::Log.info("Denoncourt opsworks_deploy ")
    app application
    deploy_data deploy
  end

  nginx_web_app application do
    Chef::Log.info("Denoncourt nginx_web_app ")
    application deploy
    cookbook "nginx"
  end
end
