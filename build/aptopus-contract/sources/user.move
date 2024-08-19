module aptopus::user {
    use std::string::{String, Self};
    use std::vector::{Self};
    use aptos_framework::signer::{Self};
    use aptos_framework::timestamp::{CurrentTimeMicroseconds, now_microseconds};
    use std::option::{Option, Self, is_none, extract};
    use aptos_framework::event;
    use aptos_framework::coin::{transfer, Self, Coin};
    use aptos_framework::aptos_coin::AptosCoin;

    const ERROR_VoteSession_EXISTED: u64 = 1;
    const ERROR_VoteSession_NOT_FOUND: u64 = 2;
    const ERROR_NOT_VOTE_SESSSION_OWNER: u64 = 3;
    const NOT_ENOUGH_votes: u64 = 3;
    const ERROR_VOTER_ALREADY_VOTE: u64 = 4;

    // struct definition for VoteSession, requires: 
    // name: user name,
    // owner: user address,
    // votes: user votes or creadits for using the chat service,
    // submited_votes: store the chat requests which have been resolved 
    struct VoteSession has key, store, copy, drop {
        id: u64,
        description: String,
        owner: address,
        votes: u64,
        is_active: bool,
        submited_votes: vector<SubmitedVote>,
    }

    //struct resolved request, it requires:
    //  owner, 
    //  num_of_tokens that is user pay for chat, 
    //  timestamp: the time when the chat request is resolved
    struct SubmitedVote has key, store, copy, drop {
        voter: address,
        timestamp: u64,
    }

    // Admin struct requires VoteSession list to store all the voteSession on the platform
    struct Admin has key, store, copy {
        vote_sessions: vector<VoteSession>,
    }


    struct Request has key, store, copy {
        owner: address,
        votes: u64,
    }

    // event
    #[event]
    struct VoteSessionCreatedEvent has drop, store {
        owner: address,
        init_time: u64,
    }



    fun init_module(s: &signer) {
        // init admin and store it in the aptopus VoteSession
        let admin = Admin {
            vote_sessions: vector::empty(), 
        };
        let admin_addr = signer::address_of(s);
        move_to(s, admin);
    }

    // function to check if the VoteSession is existed
    fun is_existed_vote_session(vote_session_id: u64): bool acquires Admin {
        let admin = borrow_global<Admin>(@aptopus);
        let vote_sessions = &admin.vote_sessions;
        let current_index  = 0;
        // loop to check if the VoteSession is existed returnvore_session_id true else return false
        while (current_index < vector::length(vote_sessions)) {
            let voteSession = vector::borrow(vote_sessions, current_index);
            if(voteSession.id == vote_session_id) {
                return true;
            };
            current_index = current_index + 1;
        };
        return false
    }


    fun is_existed_voter(vote_history: &vector<SubmitedVote>, voter: address): bool {
        let current_index  = 0;
        // loop to check if the VoteSession is existed returnvore_session_id true else return false
        while (current_index < vector::length(vote_history)) {
            let vote = vector::borrow(vote_history, current_index);
            if(vote.voter == voter) {
                return true;
            };
            current_index = current_index + 1;
        };
        return false
    }

    //entry functions
    // function to create VoteSession
    public entry fun create_vote_session(s: &signer, name: String) acquires Admin {
        // check if the VoteSession is existed
        let id = now_microseconds();
        assert!(!is_existed_vote_session(id), ERROR_VoteSession_EXISTED);
        let admin = borrow_global_mut<Admin>(@aptopus);
        // create new VoteSession
        let voteSession = VoteSession {
            id,
            description: name,
            owner: signer::address_of(s),
            votes: 0,
            is_active: true,
            submited_votes: vector::empty(),
        };
        // push the VoteSession to the admin VoteSession list
        vector::push_back(&mut admin.vote_sessions, voteSession);
    }

    // function to submit chat request
    public entry fun vote(s: &signer, vote_session_id: u64) acquires Admin {
        //todo
        //check if VoteSession is existed
        assert!(is_existed_vote_session(vote_session_id), ERROR_VoteSession_NOT_FOUND);
        let admin = borrow_global_mut<Admin>(@aptopus);
        let vote_session_index = 0;
        // loop to find VoteSession by address to handle chat request
        while (vote_session_index < vector::length(&admin.vote_sessions)) {
            let vote_session = vector::borrow_mut<VoteSession>(&mut admin.vote_sessions, vote_session_index);
            if(vote_session.id == vote_session_id) {
                assert!(!is_existed_voter(&vote_session.submited_votes, signer::address_of(s)), ERROR_VOTER_ALREADY_VOTE);
                vote_session.votes = vote_session.votes + 1;  
                store_vote_history(vote_session, signer::address_of(s));
                break;
            };
            vote_session_index = vote_session_index + 1;
        };
    }

    public entry fun close_vote_session(s: &signer, vote_session_id: u64) acquires Admin {
        //todo
        //check if VoteSession is existed
        assert!(is_existed_vote_session(vote_session_id), ERROR_VoteSession_NOT_FOUND);
        let admin = borrow_global_mut<Admin>(@aptopus);
        let vote_session_index = 0;
        // loop to find VoteSession by address to handle chat request
        while (vote_session_index < vector::length(&admin.vote_sessions)) {
            let vote_session = vector::borrow_mut<VoteSession>(&mut admin.vote_sessions, vote_session_index);
            if(vote_session.id == vote_session_id) {
                assert!(signer::address_of(s) != vote_session.owner, ERROR_NOT_VOTE_SESSSION_OWNER);
                vote_session.is_active = false;
                break;
            };
            vote_session_index = vote_session_index + 1;
        };
    }


    //view functions
    #[view]
    public fun get_VoteSession_info(id: u64): Option<VoteSession> acquires Admin {
        //check if VoteSession is existed
        if(!is_existed_vote_session(id)) {
            return option::none();
        };
        // return option of VoteSession
        return option::some(find_vote_session_by_address(id))
    }

    #[view]
    public fun get_all_vote_session(): vector<VoteSession> acquires Admin {
        let admin = borrow_global<Admin>(@aptopus);
        admin.vote_sessions
    }


    // inner function
 

    // return current votes of an VoteSession
    fun get_total_votes(voteSession: &VoteSession): u64 {
        voteSession.votes
    }

    // update votes of an VoteSession
    fun update_votes(voteSession: &mut VoteSession, votes: u64) {
        voteSession.votes = votes;
    }

    // check if VoteSession has enough creadits
    fun check_votes(voteSession: &VoteSession, num_of_token: u64): bool {
        voteSession.votes >= num_of_token
    }

    // store chat request in resolved request list
    fun store_vote_history(voteSession: &mut VoteSession, s: address) {
        //todo
        let vec = &mut voteSession.submited_votes;
        vector::push_back(vec, SubmitedVote {
            voter: s,
            timestamp: now_microseconds(),
        });
    }

    // find VoteSession by address
    fun find_vote_session_by_address(vote_session_id: u64) : VoteSession acquires Admin {
        let admin = borrow_global<Admin>(@aptopus);
        let vote_session_index = 0;
        // loop to find VoteSession by address
        while (vote_session_index < vector::length(&admin.vote_sessions)) {
            let voteSession = vector::borrow<VoteSession>(&admin.vote_sessions, vote_session_index);
            if(voteSession.id == vote_session_id) {
                return *voteSession;
            };
            vote_session_index = vote_session_index + 1;
        };
        // return empty VoteSession if not found
        return VoteSession {
            id: 0,
            description: string::utf8(b""),
            owner: @0x0cf,
            votes: 0,
            is_active: false,
            submited_votes:vector::empty(),
        }
    }
}



