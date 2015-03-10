aws_keys = YAML::load(File.open("#{Rails.root}/config/s3.yml"))
AWS::S3::Base.establish_connection!(
    :access_key_id     => aws_keys["access_key_id"],
    :secret_access_key => aws_keys["secret_access_key"]
  )
  