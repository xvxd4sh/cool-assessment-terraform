# Create the IAM instance profile for the Terraformer EC2 server
# instances

# The instance profile to be used
resource "aws_iam_instance_profile" "terraformer" {
  provider = aws.provisionassessment

  name = "terraformer_instance_profile_${terraform.workspace}"
  role = aws_iam_role.terraformer_instance_role.name
}

# The instance role
resource "aws_iam_role" "terraformer_instance_role" {
  provider = aws.provisionassessment

  name               = "terraformer_instance_role_${terraform.workspace}"
  assume_role_policy = data.aws_iam_policy_document.ec2_service_assume_role_doc.json
}

resource "aws_iam_role_policy" "terraformer_assume_delegated_role_policy" {
  provider = aws.provisionassessment

  name   = "assume_delegated_role_policy"
  role   = aws_iam_role.terraformer_instance_role.id
  policy = data.aws_iam_policy_document.terraformer_assume_delegated_role_policy_doc.json
}

# Attach the CloudWatch Agent policy to this role as well
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy_attachment_terraformer" {
  provider = aws.provisionassessment

  role       = aws_iam_role.terraformer_instance_role.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

################################
# Define the role policies below
################################

# Allow the Terraformer instance to assume the necessary role
# create/destroy/modify AWS resources.
data "aws_iam_policy_document" "terraformer_assume_delegated_role_policy_doc" {
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]
    effect = "Allow"
    resources = [
      # module.email_sending_domain_certreadrole.role.arn,
    ]
  }
}
