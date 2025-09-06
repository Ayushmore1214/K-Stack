data "aws_iam_policy_document" "github_actions_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:Ayushmore1214/K-Stack:*"]
    }
  }
}

resource "aws_iam_role" "github_actions_role" {
  name               = "github-actions-role"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role_policy.json
}

data "aws_iam_policy_document" "ecr_access_policy" {
  statement {
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]
    resources = [
      aws_ecr_repository.frontend.arn,
      aws_ecr_repository.backend.arn
    ]
  }
}

resource "aws_iam_policy" "ecr_access_policy" {
  name   = "ECRAccessPolicyForGitHubActions"
  policy = data.aws_iam_policy_document.ecr_access_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_ecr_policy" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.ecr_access_policy.arn
}