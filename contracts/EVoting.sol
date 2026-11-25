// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * @title EVoting
 * @dev Decentralized electronic voting smart contract
 */
contract EVoting {
    enum ElectionState { NotStarted, Ongoing, Ended }

    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint256 votedCandidateId;
    }

    address public admin;
    string public electionTitle;
    ElectionState public state;
    uint256 public totalVotes;

    Candidate[] public candidates;
    mapping(address => Voter) public voters;

    event ElectionStarted();
    event ElectionEnded();
    event CandidateAdded(uint256 indexed candidateId, string name);
    event VoterRegistered(address indexed voter);
    event VoteCast(address indexed voter, uint256 indexed candidateId);

    modifier onlyAdmin() {
        require(msg.sender == admin, "EVoting: Only admin can perform this action");
        _;
    }

    modifier inState(ElectionState _state) {
        require(state == _state, "EVoting: Invalid election state for this action");
        _;
    }

    constructor(string memory _electionTitle) {
        admin = msg.sender;
        electionTitle = _electionTitle;
        state = ElectionState.NotStarted;
    }

    /**
     * @dev Add a new candidate (only admin, before election starts)
     */
    function addCandidate(string memory _name) external onlyAdmin inState(ElectionState.NotStarted) {
        require(bytes(_name).length > 0, "EVoting: Candidate name cannot be empty");
        uint256 candidateId = candidates.length;
        candidates.push(Candidate({
            id: candidateId,
            name: _name,
            voteCount: 0
        }));
        emit CandidateAdded(candidateId, _name);
    }

    /**
     * @dev Authorize / register a voter (only admin, before or during election)
     */
    function registerVoter(address _voter) external onlyAdmin {
        require(_voter != address(0), "EVoting: Invalid voter address");
        require(!voters[_voter].isRegistered, "EVoting: Voter already registered");
        require(state != ElectionState.Ended, "EVoting: Cannot register after election has ended");

        voters[_voter].isRegistered = true;
        emit VoterRegistered(_voter);
    }

    /**
     * @dev Start election (only admin)
     */
    function startElection() external onlyAdmin inState(ElectionState.NotStarted) {
        require(candidates.length >= 2, "EVoting: At least 2 candidates required");
        state = ElectionState.Ongoing;
        emit ElectionStarted();
    }

    /**
     * @dev End election (only admin)
     */
    function endElection() external onlyAdmin inState(ElectionState.Ongoing) {
        state = ElectionState.Ended;
        emit ElectionEnded();
    }

    /**
     * @dev Cast vote for a candidate
     */
    function vote(uint256 _candidateId) external inState(ElectionState.Ongoing) {
        Voter storage sender = voters[msg.sender];
        require(sender.isRegistered, "EVoting: You are not registered to vote");
        require(!sender.hasVoted, "EVoting: You have already voted");
        require(_candidateId < candidates.length, "EVoting: Invalid candidate ID");

        sender.hasVoted = true;
        sender.votedCandidateId = _candidateId;

        candidates[_candidateId].voteCount += 1;
        totalVotes += 1;

        emit VoteCast(msg.sender, _candidateId);
    }

    /**
     * @dev Get total number of candidates
     */
    function getCandidatesCount() external view returns (uint256) {
        return candidates.length;
    }

    /**
     * @dev Get all candidates
     */
    function getAllCandidates() external view returns (Candidate[] memory) {
        return candidates;
    }

    /**
     * @dev Get winner candidate after election has ended
     */
    function getWinner() external view inState(ElectionState.Ended) returns (uint256 winningId, string memory winningName, uint256 winningVotes) {
        require(candidates.length > 0, "EVoting: No candidates in election");
        uint256 highestVotes = 0;
        uint256 winnerIdx = 0;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > highestVotes) {
                highestVotes = candidates[i].voteCount;
                winnerIdx = i;
            }
        }

        Candidate storage winner = candidates[winnerIdx];
        return (winner.id, winner.name, winner.voteCount);
    }
}

