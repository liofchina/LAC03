pragma solidity ^0.4.22;
contract CommonInfo{
    mapping(address => string[]) infoToOwner;
    Information[] global_infos ;
    struct Information{
        string id;
        string info_data;
        string proof_data;
        string power_data;
    }
}
