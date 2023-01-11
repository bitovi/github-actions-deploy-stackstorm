#! /bin/bash
echo "In generate_vpc_tf.sh"

if [[ $CREATE_VPC == true ]]; then
vpc_block="resource \"aws_vpc\" \"main\" {
 count = var.create_vpc == \"true\" ? 1 : 0
 cidr_block = var.vpc_cidr
 tags = {
   Name = \"\${var.aws_resource_identifier}\"
 }
}

data \"aws_vpc\" \"main\" {
  count = var.create_vpc == \"true\" ? 1 : 0  
  id = aws_vpc.main[0].id
}"
else
# Notice: Inversing the create_vpc ternary
vpc_block="data \"aws_vpc\" \"main\" {
  count = var.create_vpc == \"true\" ? 0: 1  
  id = var.vpc_arn
}"
fi

echo "$vpc_block" > $GITHUB_ACTION_PATH/operations/deployment/terraform/modules/02_generated_networking.tf
cat $GITHUB_ACTION_PATH/operations/deployment/terraform/modules/02_networking.tf.tmpl >> $GITHUB_ACTION_PATH/operations/deployment/terraform/modules/02_generated_networking.tf