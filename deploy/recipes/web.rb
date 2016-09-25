include_recipe 'deploy'
include_recipe "nginx::service"

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'static'
    Chef::Log.debug("Skipping deploy::web application #{application} as it is not an static HTML app")
    next
  end

  opsworks_deploy_dir do
    Chef::Log.info("Denoncourt added this test Chef::Log.info in opsworks_deploy_dir block")
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    Chef::Log.info("Denoncourt added this test Chef::Log.info in opsworks_deploy block")
    app application
    deploy_data deploy
  end

  nginx_web_app application do
    Chef::Log.info("Denoncourt added this test Chef::Log.info in nginx_web_app block")
    application deploy
    cookbook "nginx"
  end
end
