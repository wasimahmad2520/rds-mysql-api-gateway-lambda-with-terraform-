const {
    sendResponse,
    generateID
} = require("./utility");



const {student,dynamoDb} =require("./db")


exports.handler = async (event) => {


    const body = JSON.parse(event.body);
    // get action from body
    const {
        action
    } = body;

    const method=event.httpMethod;

     

    switch (method) {

        case  "POST":
            try {
                const {
                    first_name,
                    last_name,
                    gender,
                    description
                } = body;
                const id = generateID(10);
                const TableName = student;
                const params = {
                    TableName,
                    Item: {
                        id,
                        first_name,
                        last_name,
                        gender,
                        description
                    },
                    ConditionExpression: "attribute_not_exists(id)"
                };
                await dynamoDb.put(params).promise();
                return sendResponse(200, {
                    message: 'Student created successfully'
                })
            } catch (e) {
                return sendResponse(500, {
                    message: 'Could not create the Student ' + e
                });
            }
            break;



            // Reaad all the students
        case 'GET':

            try {
                const {
                    id
                } = body;
                const params = {
                    TableName: student,
                    KeyConditionExpression: "id = :id",
                    ExpressionAttributeValues: {
                        ":id": id
                    },
                    Select: "ALL_ATTRIBUTES"
                };

                const data = await dynamoDb.query(params).promise();
                if (data.Count > 0) {
                    return sendResponse(200, {
                        item: data.Items
                    });
                } else {
                    return sendResponse(404, {
                        message: "Student not found"
                    });
                }
            } catch (e) {
                return sendResponse(500, {
                    message: "Could not get the Student"
                });
            }

            // code
            break;




            // Update student
        case 'PUT':
            // code

            try {
                const {
                    first_name,
                    last_name,
                    gender,
                    description,
                    id
                } = body;
                const params = {
                    TableName: student,
                    Key: {
                        id
                    },
                    ExpressionAttributeValues: {
                        ":first_name": first_name,
                        ":last_name": last_name,
                        ":gender": gender,
                        ":description": description
                    },
                    UpdateExpression: "SET first_name = :first_name, last_name = :last_name, gender = :gender, description = :description",
                    ReturnValues: "ALL_NEW"
                };

                const data = await dynamoDb.update(params).promise();
                if (data.Attributes) {
                    return sendResponse(200, data.Attributes);
                } else {
                    return sendResponse(404, {
                        message: "Updated Student data not found"
                    });
                }
            } catch (e) {
                return sendResponse(500, {
                    message: "Could not update this Student"
                });
            }




            break;

            // Delete Student
        case 'DELETE':
            // code

            try {
                const {
                    id
                } = body;
                const params = {
                    TableName: student,
                    Key: {
                        id
                    }
                };
                await dynamoDb.delete(params).promise();
                return sendResponse(200, {
                    message: "Student deleted successfully"
                });
            } catch (e) {
                return sendResponse(500, {
                    message: "Could not delete the Student"
                });
            }


            break;

        default:
            // code
    }




    // return response;
};
