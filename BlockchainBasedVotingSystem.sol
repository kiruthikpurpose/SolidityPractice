// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        bool hasVoted;
        uint candidateId;
    }

    address public owner;
    mapping(uint => Candidate) public candidates;
    mapping(address => Voter) public voters;
    uint public candidatesCount;
    bool public electionEnded;

    event ElectionEnded();
    event Voted(address indexed voter, uint candidateId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    modifier electionOngoing() {
        require(!electionEnded, "The election has ended.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addCandidate(string memory _name) public onlyOwner {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    function vote(uint _candidateId) public electionOngoing {
        require(!voters[msg.sender].hasVoted, "You have already voted.");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate.");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].candidateId = _candidateId;
        
        candidates[_candidateId].voteCount++;

        emit Voted(msg.sender, _candidateId);
    }

    function endElection() public onlyOwner {
        electionEnded = true;
        emit ElectionEnded();
    }

    function getCandidate(uint _candidateId) public view returns (uint, string memory, uint) {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate.");
        Candidate memory candidate = candidates[_candidateId];
        return (candidate.id, candidate.name, candidate.voteCount);
    }
}
