// This file simply declares the AutoEquatable protocol,
// which tells Sourcery to generate equatable extensions.

public protocol AutoEquatable {}

extension Git: AutoEquatable {}
extension GitCommit: AutoEquatable {}
extension GitCommitAuthor: AutoEquatable {}

extension GitHubUser: AutoEquatable {}
extension GitHubMilestone: AutoEquatable {}
extension GitHub: AutoEquatable {}
extension GitHubPR: AutoEquatable {}
extension GitHubTeam: AutoEquatable {}
extension GitHubRequestedReviewers: AutoEquatable {}
extension GitHubMergeRef: AutoEquatable {}
extension GitHubRepo: AutoEquatable {}
extension GitHubReview: AutoEquatable {}
extension GitHubCommit: AutoEquatable {}
extension GitHubIssue: AutoEquatable {}
extension GitHubIssueLabel: AutoEquatable {}
