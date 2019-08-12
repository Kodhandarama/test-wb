pragma solidity >=0.4.25 <0.6.0;

import "./Voter_1.sol";

contract Election_1 {
    enum StateType {Initialisation, Enter_detail, Authentication, Result}

    StateType public State;
    address public ElectionCommission;
    int public Const_ID;
    int[] public Candidates;
    uint[] result;
    int public Winner;
    uint  Winner_index;
    string public VoterID;
    address public CurrentContractAddress;
    Voter_1 currentVoter;

    constructor(int const_ID, int[] memory candidates) public
    {
        ElectionCommission = msg.sender;
        Const_ID = int(const_ID);
        Candidates = candidates;
        CurrentContractAddress = address(this);

        for (uint i = 0; i < candidates.length; i++)
        {
            result.push(0);
        }
        State = StateType.Initialisation;
    }

    function Authentication(bool flag) public
    {
        if( ElectionCommission != msg.sender)
        {
            revert();
        }
        if (flag)
        {
            currentVoter = new Voter_1(Const_ID, CurrentContractAddress, VoterID, ElectionCommission);
        }
        State = StateType.Enter_detail;
    }
    function Enter_detail( string  memory Voter_ID) public
    {
        VoterID = Voter_ID;
        State = StateType.Authentication;
    }
    function startVoting() public
    {
         if( ElectionCommission != msg.sender)
        {
            revert();
        }
        State = StateType.Enter_detail;
    }
    function update(int Candidate_ID) public
    {
        for (uint i = 0; i < Candidates.length;i++)
        {
            if(Candidates[i] == Candidate_ID)
            {
                result[i] += 1;
            }
        }
    }
    function cal_vote() public
    {
         if( ElectionCommission != msg.sender)
        {
            revert();
        }
        uint temp;
        for (uint i = 1; i < Candidates.length; i++)
        {
            temp = result[0];
            Winner_index = 0;
            if(temp < result[i])
            {
                temp = result[i];
                Winner_index = i;
            }
        }
        Winner = int(Candidates[Winner_index]);
        State = StateType.Result;
    }
}