# ------------------------------------------------------------------------------
# Attach VPC to the Transit Gateway in the Shared Services account
# (see https://github.com/cisagov/cool-sharedservices-networking).
#
# Note that this attachment will be automatically accepted as long
# as the Transit Gateway was set up with:
#  auto_accept_shared_attachments = "enable"
#
# Note also that we are associating to the TGW VPC attachment a
# particular route table.  This route table allows communication to
# the Shared Services account, but nowhere else.  This serves to
# isolate the assessment accounts from each other.
# ------------------------------------------------------------------------------

resource "aws_ec2_transit_gateway_vpc_attachment" "assessment" {
  provider = aws.provisionassessment

  # All subnets of the VPC are currently in the same availability
  # zone, so it doesn't matter which subnet ID we use for the Transit
  # Gateway attachment.  We chose to put it in the subnet containing the
  # Guacamole instance in order to simplify the ACL rules for LDAP/Kerberos
  # traffic between Guacamole and the Transit Gateway attachment.
  subnet_ids         = [aws_subnet.private[var.private_subnet_cidr_blocks[0]].id]
  tags               = var.tags
  transit_gateway_id = local.transit_gateway_id
  vpc_id             = aws_vpc.assessment.id
}

resource "aws_ec2_transit_gateway_route_table_association" "association" {
  provider = aws.provisionsharedservices

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.assessment.id
  transit_gateway_route_table_id = local.transit_gateway_route_table_id
}

# Add a route to the assessment VPC.
resource "aws_ec2_transit_gateway_route" "assessment_route" {
  provider = aws.provisionsharedservices

  destination_cidr_block         = aws_vpc.assessment.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.assessment.id
  transit_gateway_route_table_id = local.transit_gateway_route_table_id
}
