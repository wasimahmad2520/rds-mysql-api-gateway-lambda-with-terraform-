    const AWS = require("aws-sdk");

    const student="advanced_student";
    // AWS.config.update({region: 'us-west-2'});
    const dynamoDb = new AWS.DynamoDB.DocumentClient();
    module.exports={
    student,
    dynamoDb
    }





