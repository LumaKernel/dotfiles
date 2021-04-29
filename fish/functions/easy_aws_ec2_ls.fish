alias easy_aws_ec2_ls=(echo "
  aws ec2 describe-instances --query '
    Reservations[*]
    .Instances[0]
    .{
      iid: InstanceId,
      name: Tags[?Key == `Name`].Value|[0],
      itype: InstanceType,
      az: Placement.AvailabilityZone,
      dns: PrivateDnsName
    }
  '
" | string join ' ')
