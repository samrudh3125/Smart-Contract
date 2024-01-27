pragma solidity ^0.8.0;

contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == msg.sender);
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(owner() == msg.sender);
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract CourseRegistration is Ownable{
    uint public coursefee;
    Payment[] public payments; 

    struct Payment{
        address user;
        string email;
        uint amount;
    }

    event PaymentRecieved(address indexed user,string email, uint amount);

    constructor(uint _coursefee)Ownable(msg.sender){
        coursefee = _coursefee;
    }

    function payForCourse(string memory email)public payable{
        require(msg.value == coursefee,"Payment should be equal to course fee");
        Payment memory payment = Payment(msg.sender,email,msg.value);
        payments.push(payment);
        emit PaymentRecieved(msg.sender,email,msg.value);
    }

    function withdrawFunds()public onlyOwner{
        payable(owner()).transfer(address(this).balance);
    }

    function getPaymentsByUser(address user)public view returns(Payment[] memory){
        uint count=0;
        for(uint i=0;i<payments.length;i++){
            if(payments[i].user == user){
                count++;
            }
        }

        Payment[] memory paymentsByUser = new Payment[](count);
        uint j=0;
        for(uint i=0;i<payments.length;i++){
            if(payments[i].user == user){
                paymentsByUser[j] = payments[i];
                j++;
            }
        }
        return paymentsByUser;
    }

    function getAllPayments()public view returns(Payment[] memory){
        return payments;
    }
}