pragma solidity ^0.4.22;
import "./CommonInfo.sol";
import "./Ownable.sol";
import "github.com/Arachnid/solidity-stringutils/strings.sol";

contract LAC03 is Ownable, CommonInfo {
    using strings for *;
    event cochain_event(address _publisher, string _infoId);
    event update_cochain_event(address _publisher, string _infoId, bool result, string desc);

    constructor() public {
        owner = msg.sender;
    }

    function cochain(string _id, string _info_data,  string  _proof_data, string _power_data) external {
        require(bytes(_id).length > 0, "ID cannot be empty");
        Information memory _info ;
        bool flag = false;
        for(uint  i=0; i < global_infos.length; i++){
            if( keccak256(global_infos[i].id) == keccak256(_id)){
                //global_infos[i] = Information(_id, _info_data, _proof_data, _power_data);
                flag = true;
                break;
            }
        }
        if(!flag){
            _info = Information(_id, _info_data,  _proof_data, _power_data);
            global_infos.push(_info);
            infoToOwner[msg.sender].push(_id);
        }
        emit cochain_event(msg.sender, _id);
    }

    function getInfoByInfoId(string memory _infoId) public view returns(string, string,  string, string){
        require(bytes(_infoId).length > 0, "ID cannot be empty");
        Information memory info ;
        for(uint  i=0; i < global_infos.length; i++){
            if( keccak256(global_infos[i].id) == keccak256(_infoId)){
                info = global_infos[i];
                break;
            }
        }
        return (info.id, info.info_data,  info.proof_data, info.power_data);
    }

    function updateCochain(string _id, string _info_data,  string  _proof_data, string _power_data) external returns(bool, string){
        require(bytes(_id).length > 0, "ID cannot be empty");
        bool flag = false;
        for(uint  i=0; i < global_infos.length; i++){
            if( keccak256(global_infos[i].id) == keccak256(_id)){
                if(keccak256(global_infos[i].info_data) != keccak256(_info_data)){
                    global_infos[i].info_data = _info_data;
                }
                if(keccak256(global_infos[i].proof_data) != keccak256(_proof_data)){
                    global_infos[i].proof_data = _proof_data;
                }
                if(keccak256(global_infos[i].power_data) != keccak256(_power_data)){
                    global_infos[i].power_data = _power_data;
                }
                flag = true;
                break;
            }
        }
        string memory desc = flag?"Update info success":"No ID found";
        emit update_cochain_event(msg.sender, _id, flag, desc);
        return (flag, desc);
    }

}
