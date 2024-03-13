// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/// @title Ballot
/// @dev Implements voting process along with vote delegation

contract Ballot {

    struct Voter {
        // weight is accumulated by delegation
        uint weight;
        // if true - that person already voted
        bool voted;
        // person delgated to
        address delegate;
        // index of the voted proposal
        uint vote;
    }

    struct Proposal {
        // short name (up to 32 bytes)
        bytes32 name;
        // number of accumulated votes
        uint voteCount;
    }

    address public chairperson;

    mapping(address => Voter) public voters;

    Proposal[] public proposals;

    /// @dev Create a new ballot to choose one of 'proposalNames'.
    /// @param proposalNames names of proposals

    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        for (uint i = 0; i < proposalNames.length; i++) {
            // Proposal({ }) - creates a temporary Proposal object.
            // proposals.push() - appends the Proposal to the end of proposals.
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    /// @dev Give 'voter' the right to vote on this ballot. May only be called by 'chairperson'.
    /// @param voter address of voter

    function GiveRightToVote(address voter) public {
        require(msg.sender == chairperson, "Only chairperson can give right to vote.");
        require(!voters[voter].voted, "The voter already voted.");
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    /// @dev Delegate your vote to the voter 'to'.
    /// @param to address to which vote is delegated

    function delegate(address to) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "Yoy already voted.");
        require(to != msg.sender, "Self-delegation is disallowed.");

        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            // We found a loop in the delegation, not allowed.
            require(to != msg.sender, "Found loop in delegation.");
        }
        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];
        if (delegate_.voted) {
            // if the delegate already voted' directly add to the number of votes
            proposals[delegate_.vote].voteCount += sender.weight;
        }
        else {
            // if the delegate didnwt vote yet, add to her weight
            delegate_.weight += sender.weight;
        }
    }

    /// @dev Give your vote (including votes delegated to you) to proposal 'proposals[proposal].name'.
    /// @param proposal index of proposal in the proposals array

    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight !=0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;

        // if 'proposal' is out of the range of the array, this will throw automatically and revent all changes.
        proposals[proposal].voteCount += sender.weight;
    }

    /// @dev Computes the winning proposal taking all previous votes into account.
    /// @return winningProposal_ index of winning proposal in the proposal array

    function winningProposal() public view returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ =p;
            }
        }
    }

    /// @dev Calls winningProposal() function to get the index of the winner contained in the proposals array and then
    /// @return winnerName_ the name of the winner

    function winnerName() public view returns (bytes32 winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    } 

}
