// Generated using Sourcery 0.10.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Danger

// swiftlint:disable file_length
fileprivate func compareOptionals<T>(lhs: T?, rhs: T?, compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    switch (lhs, rhs) {
    case let (lValue?, rValue?):
        return compare(lValue, rValue)
    case (nil, nil):
        return true
    default:
        return false
    }
}

fileprivate func compareArrays<T>(lhs: [T], rhs: [T], compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for (idx, lhsItem) in lhs.enumerated() {
        guard compare(lhsItem, rhs[idx]) else { return false }
    }

    return true
}


// MARK: - AutoEquatable for classes, protocols, structs
// MARK: - Git AutoEquatable
extension Git: Equatable {}
public func == (lhs: Git, rhs: Git) -> Bool {
    guard lhs.modifiedFiles == rhs.modifiedFiles else { return false }
    guard lhs.createdFiles == rhs.createdFiles else { return false }
    guard lhs.deletedFiles == rhs.deletedFiles else { return false }
    return true
}
// MARK: - GitCommit AutoEquatable
extension GitCommit: Equatable {}
public func == (lhs: GitCommit, rhs: GitCommit) -> Bool {
    guard compareOptionals(lhs: lhs.sha, rhs: rhs.sha, compare: ==) else { return false }
    guard lhs.author == rhs.author else { return false }
    guard lhs.committer == rhs.committer else { return false }
    guard lhs.message == rhs.message else { return false }
    guard compareOptionals(lhs: lhs.parents, rhs: rhs.parents, compare: ==) else { return false }
    guard lhs.url == rhs.url else { return false }
    return true
}
// MARK: - GitCommitAuthor AutoEquatable
extension GitCommitAuthor: Equatable {}
public func == (lhs: GitCommitAuthor, rhs: GitCommitAuthor) -> Bool {
    guard lhs.name == rhs.name else { return false }
    guard lhs.email == rhs.email else { return false }
    guard lhs.date == rhs.date else { return false }
    return true
}
// MARK: - GitHub AutoEquatable
extension GitHub: Equatable {}
public func == (lhs: GitHub, rhs: GitHub) -> Bool {
    guard lhs.issue == rhs.issue else { return false }
    guard lhs.pullRequest == rhs.pullRequest else { return false }
    guard lhs.commits == rhs.commits else { return false }
    guard lhs.reviews == rhs.reviews else { return false }
    guard lhs.requestedReviewers == rhs.requestedReviewers else { return false }
    return true
}
// MARK: - GitHubCommit AutoEquatable
extension GitHubCommit: Equatable {}
public func == (lhs: GitHubCommit, rhs: GitHubCommit) -> Bool {
    guard lhs.sha == rhs.sha else { return false }
    guard lhs.commit == rhs.commit else { return false }
    guard lhs.url == rhs.url else { return false }
    guard lhs.author == rhs.author else { return false }
    guard lhs.committer == rhs.committer else { return false }
    return true
}
// MARK: - GitHubIssue AutoEquatable
extension GitHubIssue: Equatable {}
public func == (lhs: GitHubIssue, rhs: GitHubIssue) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.number == rhs.number else { return false }
    guard lhs.title == rhs.title else { return false }
    guard lhs.user == rhs.user else { return false }
    guard lhs.state == rhs.state else { return false }
    guard lhs.isLocked == rhs.isLocked else { return false }
    guard lhs.body == rhs.body else { return false }
    guard lhs.commentCount == rhs.commentCount else { return false }
    guard compareOptionals(lhs: lhs.assignee, rhs: rhs.assignee, compare: ==) else { return false }
    guard lhs.assignees == rhs.assignees else { return false }
    guard compareOptionals(lhs: lhs.milestone, rhs: rhs.milestone, compare: ==) else { return false }
    guard lhs.createdAt == rhs.createdAt else { return false }
    guard lhs.updatedAt == rhs.updatedAt else { return false }
    guard compareOptionals(lhs: lhs.closedAt, rhs: rhs.closedAt, compare: ==) else { return false }
    guard lhs.labels == rhs.labels else { return false }
    return true
}
// MARK: - GitHubIssueLabel AutoEquatable
extension GitHubIssueLabel: Equatable {}
public func == (lhs: GitHubIssueLabel, rhs: GitHubIssueLabel) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.url == rhs.url else { return false }
    guard lhs.name == rhs.name else { return false }
    guard lhs.color == rhs.color else { return false }
    return true
}
// MARK: - GitHubMergeRef AutoEquatable
extension GitHubMergeRef: Equatable {}
public func == (lhs: GitHubMergeRef, rhs: GitHubMergeRef) -> Bool {
    guard lhs.label == rhs.label else { return false }
    guard lhs.ref == rhs.ref else { return false }
    guard lhs.sha == rhs.sha else { return false }
    guard lhs.user == rhs.user else { return false }
    guard lhs.repo == rhs.repo else { return false }
    return true
}
// MARK: - GitHubMilestone AutoEquatable
extension GitHubMilestone: Equatable {}
public func == (lhs: GitHubMilestone, rhs: GitHubMilestone) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.number == rhs.number else { return false }
    guard lhs.state == rhs.state else { return false }
    guard lhs.title == rhs.title else { return false }
    guard lhs.description == rhs.description else { return false }
    guard lhs.creator == rhs.creator else { return false }
    guard lhs.openIssues == rhs.openIssues else { return false }
    guard lhs.closedIssues == rhs.closedIssues else { return false }
    guard lhs.createdAt == rhs.createdAt else { return false }
    guard lhs.updatedAt == rhs.updatedAt else { return false }
    guard compareOptionals(lhs: lhs.closedAt, rhs: rhs.closedAt, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.dueOn, rhs: rhs.dueOn, compare: ==) else { return false }
    return true
}
// MARK: - GitHubPR AutoEquatable
extension GitHubPR: Equatable {}
public func == (lhs: GitHubPR, rhs: GitHubPR) -> Bool {
    guard lhs.number == rhs.number else { return false }
    guard lhs.title == rhs.title else { return false }
    guard lhs.body == rhs.body else { return false }
    guard lhs.user == rhs.user else { return false }
    guard compareOptionals(lhs: lhs.assignee, rhs: rhs.assignee, compare: ==) else { return false }
    guard lhs.assignees == rhs.assignees else { return false }
    guard lhs.createdAt == rhs.createdAt else { return false }
    guard lhs.updatedAt == rhs.updatedAt else { return false }
    guard compareOptionals(lhs: lhs.closedAt, rhs: rhs.closedAt, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.mergedAt, rhs: rhs.mergedAt, compare: ==) else { return false }
    guard lhs.head == rhs.head else { return false }
    guard lhs.base == rhs.base else { return false }
    guard lhs.state == rhs.state else { return false }
    guard lhs.isLocked == rhs.isLocked else { return false }
    guard lhs.isMerged == rhs.isMerged else { return false }
    guard lhs.commitCount == rhs.commitCount else { return false }
    guard lhs.commentCount == rhs.commentCount else { return false }
    guard lhs.reviewCommentCount == rhs.reviewCommentCount else { return false }
    guard lhs.additions == rhs.additions else { return false }
    guard lhs.deletions == rhs.deletions else { return false }
    guard lhs.changedFiles == rhs.changedFiles else { return false }
    guard compareOptionals(lhs: lhs.milestone, rhs: rhs.milestone, compare: ==) else { return false }
    return true
}
// MARK: - GitHubRepo AutoEquatable
extension GitHubRepo: Equatable {}
public func == (lhs: GitHubRepo, rhs: GitHubRepo) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.name == rhs.name else { return false }
    guard lhs.fullName == rhs.fullName else { return false }
    guard lhs.owner == rhs.owner else { return false }
    guard lhs.isPrivate == rhs.isPrivate else { return false }
    guard lhs.description == rhs.description else { return false }
    guard lhs.isFork == rhs.isFork else { return false }
    guard lhs.htmlURL == rhs.htmlURL else { return false }
    return true
}
// MARK: - GitHubRequestedReviewers AutoEquatable
extension GitHubRequestedReviewers: Equatable {}
public func == (lhs: GitHubRequestedReviewers, rhs: GitHubRequestedReviewers) -> Bool {
    guard lhs.users == rhs.users else { return false }
    guard lhs.teams == rhs.teams else { return false }
    return true
}
// MARK: - GitHubReview AutoEquatable
extension GitHubReview: Equatable {}
public func == (lhs: GitHubReview, rhs: GitHubReview) -> Bool {
    guard lhs.user == rhs.user else { return false }
    guard compareOptionals(lhs: lhs.id, rhs: rhs.id, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.body, rhs: rhs.body, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.commitId, rhs: rhs.commitId, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.state, rhs: rhs.state, compare: ==) else { return false }
    return true
}
// MARK: - GitHubTeam AutoEquatable
extension GitHubTeam: Equatable {}
public func == (lhs: GitHubTeam, rhs: GitHubTeam) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.name == rhs.name else { return false }
    return true
}
// MARK: - GitHubUser AutoEquatable
extension GitHubUser: Equatable {}
public func == (lhs: GitHubUser, rhs: GitHubUser) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.login == rhs.login else { return false }
    guard lhs.userType == rhs.userType else { return false }
    return true
}

// MARK: - AutoEquatable for Enums
