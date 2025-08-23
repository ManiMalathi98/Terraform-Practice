resource "aws_iam_user" "iam_user" {
    name = "Mani-user"
    tags = {
        Name="Mani-user"
    }
  
}

resource "aws_iam_user_policy_attachment" "ec2_full_access" {
  user = aws_iam_user.iam_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_user_policy_attachment" "admin_full_access" {
  user = aws_iam_user.iam_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}