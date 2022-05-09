
const {
    sendResponse,
    generateID
} = require("./utility");


const sequelize = require('./database');
const Student = require('./models/student');


exports.handler = async (event) => {
    const body = JSON.parse(event.body);

  const {action}=body;

      const checkConnection=async ()=>{
    try {
        await sequelize.authenticate();
        console.log('Connection has been established successfully.');
        
      } catch (error) {
        console.error('Unable to connect to the database:', error);
       
      }
  }
  const result=await checkConnection();
//   const st=await Student.create({ first_name: 'Max', last_name: 'test@test.com' });
    // TODO implement
    // const response = {
    //     statusCode: 500,
    //     body: JSON.stringify('Final  connect from Lambda! '+action),
    // };
    // return response;
   let student;
    switch(action){
        case "create":
            console.log("create");
            var  {first_name,last_name}=body;
             student=await Student.create({ first_name: first_name, last_name: last_name });
            return sendResponse(200, {
                message: 'Student created successfully',
                student:{...student}               
             });
              
                
            break;

            case "read":
            var {id}=body;
            student=await Student.findByPk(id);
            return sendResponse(200, {
                message: 'Student read successfully'  ,
                student:{...student}             
             });
            break;

            case "update":
            var {first_name,last_name,id}=body;
           student=await Student.update(
                { first_name: first_name,last_name:last_name },
                { where: { id: id } }
              )
            return sendResponse(200, {
                message: 'Student update successfully' ,
                student:{...student}              
             });
            break;

            case "delete":
            var {id}=body;
            student=await Student.destroy({
                where: { id: id }
              })
            return sendResponse(200, {
                message: 'Student delete successfully' ,
                student:{...student}              
             });
            break;

    }

    // return sendResponse(200, {
    //     message: 'Student created successfully'
    // })
    // {
    
    //     "action":"create",
    //     "fist_name":"Wasim",
    //     "last_name":"Ahmad"
    // }

};
    // handler({action:"read"});

