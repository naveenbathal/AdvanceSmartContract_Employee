pragma solidity ^0.5.1;

contract employee
{
    
    event salary(address to,uint amount);
    address owner;
    struct newemployee
    {   uint id;
        string name;
        uint age;
        uint256 blocknumber;
        string position;
        
    }
        
 newemployee[] public emplist;
 uint empcount;
 
 mapping(address=>uint) Salary;
 
 constructor(address _owner) public
 {
     owner=_owner;
     empcount=0;
 }
 
 
 function addnewEmployee(uint _id,string memory _name,uint _age,string memory _position,uint _salary,address _emp) public onlyowner
 {
     emplist.push(newemployee(_id,_name,_age,block.number,_position));
     Salary[_emp]=_salary;
     empcount++;
     
     
     
 }
 modifier onlyowner()
 {
     require(tx.origin==owner,"only the owner can call it");
     _;
 }
  function EmployeeSalary(address from) private view returns(uint)
    {
        return(Salary[from]);
    }
    
    function callSalary(address from) public view returns(uint)
    {
        uint balance=EmployeeSalary(from);
        return balance;
        
    }
    
function calBonus(address _emp) public view returns(uint)
{
    require(tx.origin==owner);
    uint bonus=Salary[_emp] * 2;
    return bonus;
    
}
function transferSalary(address payable _emp)  payable  public onlyowner
{
  _emp.transfer(msg.value);
  emit salary(_emp,msg.value);
}

}


contract Factory {
    
    uint public employeeId;
    
    mapping(uint =>employee) employeeList;
    
    event NewEmployee(uint id );
    
    function deployEmployee(address _owner) public {
        employeeId++;
       employee e = new employee(_owner);
       employeeList[employeeId] = e;
        emit NewEmployee(employeeId);
    }
    
    function getemployeeById(uint _id) public view returns (employee) {
       return employeeList[_id];
    }
}


contract Dashboard
{
    Factory database;
      
      constructor(address _database) public {
        database = Factory(_database);
    }
    
    function newEmployee(address _owner) public  {
        database.deployEmployee(_owner);
    }
    
    function getaddnewEmployeebyId(uint _id,uint _employeeid,string memory _name,uint _age,string memory _position,uint _salary,address _emp) public  returns(uint) {
        employee e= employee(database.getemployeeById(_id));
       e.addnewEmployee(_employeeid,_name,_age,_position,_salary,_emp);
       
       
    }
    
     function getcallSalarybyId(uint _id,address from) public view returns(uint) {
        employee e= employee(database.getemployeeById(_id));
       uint sal=e.callSalary(from);
       return(sal);
       
       
    }
    
      function getcallBalancebyId(uint _id,address from) public view returns(uint) {
        employee e= employee(database.getemployeeById(_id));
       uint bonus=e.calBonus(from);
       return(bonus);
       
       
    }
    
    
      function gettransfersalarybyId(uint _id,address payable _emp) public payable  {
        employee e= employee(database.getemployeeById(_id));
       e.transferSalary.value(msg.value)(_emp);
       
       
    }
    
    
    
}