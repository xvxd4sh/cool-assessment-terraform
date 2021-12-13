# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "assessment_account_name" {
  type        = string
  description = "The name of the AWS account for this assessment (e.g. \"env0\")."
}

variable "operations_subnet_cidr_block" {
  type        = string
  description = "The operations subnet CIDR block for this assessment (e.g. \"10.10.0.0/24\")."
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "The list of private subnet CIDR blocks for this assessment (e.g. [\"10.10.1.0/24\", \"10.10.2.0/24\"])."
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block to use this assessment's VPC (e.g. \"10.224.0.0/21\")."
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "assessor_account_role_arn" {
  type        = string
  description = "The ARN of an IAM role that can be assumed to create, delete, and modify AWS resources in a separate assessor-owned AWS account."
  default     = "arn:aws:iam::123456789012:role/Allow_It"
}

variable "aws_availability_zone" {
  type        = string
  description = "The AWS availability zone to deploy into (e.g. a, b, c, etc.)"
  default     = "a"
}

variable "aws_region" {
  type        = string
  description = "The AWS region where the non-global resources for this assessment are to be provisioned (e.g. \"us-east-1\")."
  default     = "us-east-1"
}

variable "cert_bucket_name" {
  type        = string
  description = "The name of the AWS S3 bucket where certificates are stored."
  default     = "cisa-cool-certificates"
}

# TODO: This should be able to be pulled from a remote state
variable "cool_domain" {
  type        = string
  description = "The domain where the COOL resources reside (e.g. \"cool.cyber.dhs.gov\")."
  default     = "cool.cyber.dhs.gov"
}

variable "dns_ttl" {
  type        = number
  description = "The TTL value to use for Route53 DNS records (e.g. 86400).  A smaller value may be useful when the DNS records are changing often, for example when testing."
  default     = 60
}

variable "efs_access_point_gid" {
  type        = number
  description = "The group ID that should be used for file-system access to the EFS share (e.g. 2048).  Note that this value should match the GID of any group given ownership of the EFS share mount point."
  default     = 2048
}

variable "efs_access_point_uid" {
  type        = number
  description = "The user ID that should be used for file-system access to the EFS share (e.g. 2048).  Note that this value should match the UID of any user given ownership of the EFS share mount point."
  default     = 2048
}

variable "efs_users_group_name" {
  type        = string
  description = "The name of the POSIX group that should have ownership of a mounted EFS share (e.g. \"efs_users\")."
  default     = "efs_users"
}

variable "email_sending_domains" {
  type        = list(string)
  description = "The list of domains to send emails from within the assessment environment (e.g. [ \"example.com\" ]).  Teamserver and Gophish instances will be deployed with each sequential domain in the list, so teamserver0 and gophish0 will get the first domain, teamserver1 and gophish1 will get the second domain, and so on.  If there are more Teamserver or Gophish instances than email-sending domains, the domains in the list will be reused in a wrap-around fashion. For example, if there are three Teamservers and only two email-sending domains, teamserver0 will get the first domain, teamserver1 will get the second domain, and teamserver2 will wrap-around back to using the first domain."
  default     = ["example.com"]
}

variable "guac_connection_setup_path" {
  type        = string
  description = "The full path to the dbinit directory where initialization files must be stored in order to work properly. (e.g. \"/var/guacamole/dbinit\")"
  default     = "/var/guacamole/dbinit"
}

variable "inbound_ports_allowed" {
  type        = map(list(object({ protocol = string, from_port = number, to_port = number })))
  description = "A map specifying the ports allowed inbound (from anywhere) to the various instance types (e.g. {\"kali\": [{\"protocol\": \"tcp\", \"from_port\": 443, \"to_port\": 443}, {\"protocol\": \"tcp\", \"from_port\": 9000, \"to_port\": 9009}]}).  The currently-supported keys are: \"assessorportal\", \"debiandesktop\", \"gophish\", \"kali\", \"nessus\", \"pentestportal\", \"samba\", \"teamserver\", \"terraformer\", and \"windows\"."
  default     = { "assessorportal" : [], "debiandesktop" : [], "gophish" : [], "kali" : [], "nessus" : [], "pentestportal" : [], "samba" : [], "teamserver" : [], "terraformer" : [], "windows" : [] }
}

variable "nessus_activation_codes" {
  type        = list(string)
  description = "The list of Nessus activation codes (e.g. [\"AAAA-BBBB-CCCC-DDDD\"]). The number of codes in this list should match the number of Nessus instances defined in operations_instance_counts."
  default     = []
}

variable "operations_instance_counts" {
  type        = map(number)
  description = "A map specifying how many instances of each type should be created in the operations subnet (e.g. { \"kali\": 1 }).  The currently-supported instance keys are: [\"assessorportal\", \"debiandesktop\", \"gophish\", \"kali\", \"nessus\", \"pentestportal\", \"samba\", \"teamserver\", \"terraformer\"]."
  default     = { "kali" : 1 }
}

variable "private_domain" {
  type        = string
  description = "The local domain to use for this assessment (e.g. \"env0\"). If not provided, `local.private_domain` will be set to the base of the assessment account name.  For example, if the account name is \"env0 (Staging)\", `local.private_domain` will default to \"env0\".  Note that `local.private_domain` should be used in place of `var.private_domain` throughout this project."
  default     = ""
}

variable "provisionaccount_role_name" {
  type        = string
  description = "The name of the IAM role that allows sufficient permissions to provision all AWS resources in the assessment account."
  default     = "ProvisionAccount"
}

variable "provisionassessment_policy_description" {
  type        = string
  description = "The description to associate with the IAM policy that allows provisioning of the resources required in the assessment account."
  default     = "Allows provisioning of the resources required in the assessment account."
}

variable "provisionassessment_policy_name" {
  type        = string
  description = "The name to assign the IAM policy that allows provisioning of the resources required in the assessment account."
  default     = "ProvisionAssessment"
}

variable "read_terraform_state_role_name" {
  type        = string
  description = "The name to assign the IAM role (as well as the corresponding policy) that allows read-only access to the cool-assessment-terraform state in the S3 bucket where Terraform state is stored.  The %s in this name will be replaced by the value of the assessment_account_name variable."
  default     = "ReadCoolAssessmentTerraformTerraformState-%s"
}

variable "ssm_key_nessus_admin_password" {
  type        = string
  description = "The AWS SSM Parameter Store parameter that contains the password of the Nessus admin user (e.g. \"/nessus/assessment/admin_password\")."
  default     = "/nessus/assessment/admin_password"
}

variable "ssm_key_nessus_admin_username" {
  type        = string
  description = "The AWS SSM Parameter Store parameter that contains the username of the Nessus admin user (e.g. \"/nessus/assessment/admin_username\")."
  default     = "/nessus/assessment/admin_username"
}

variable "ssm_key_samba_username" {
  type        = string
  description = "The AWS SSM Parameter Store parameter that contains the username of the Samba user (e.g. \"/samba/username\")."
  default     = "/samba/username"
}

variable "ssm_key_vnc_username" {
  type        = string
  description = "The AWS SSM Parameter Store parameter that contains the username of the VNC user (e.g. \"/vnc/username\")."
  default     = "/vnc/username"
}

variable "ssmsession_role_description" {
  type        = string
  description = "The description to associate with the IAM role (and policy) that allows creation of SSM SessionManager sessions to any EC2 instance in this account."
  default     = "Allows creation of SSM SessionManager sessions to any EC2 instance in this account."
}

variable "ssmsession_role_name" {
  type        = string
  description = "The name to assign the IAM role (and policy) that allows creation of SSM SessionManager sessions to any EC2 instance in this account."
  default     = "StartStopSSMSession"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all AWS resources created"
  default     = {}
}

variable "terraformer_role_description" {
  type        = string
  description = "The description to associate with the IAM role (and policy) that allows Terraformer instances to create appropriate AWS resources in this account."
  default     = "Allows Terraformer instances to create appropriate AWS resources in this account."
}

variable "terraformer_role_name" {
  type        = string
  description = "The name to assign the IAM role (and policy) that allows Terraformer instances to create appropriate AWS resources in this account."
  default     = "Terraformer"
}

variable "windows_with_docker" {
  type        = bool
  description = "A boolean to control the instance type used when creating Windows instances to allow Docker Desktop support. Windows instances require the `metal` instance type to run Docker Desktop because of nested virtualization, but if Docker Desktop is not needed then other instance types are fine."
  default     = false
}
