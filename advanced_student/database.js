const Sequelize = require('sequelize');

const sequelize = new Sequelize('student', 'wasimahmad', 'wasimahmad', {
  dialect: 'mysql',
  define: {
    timestamps: false
},
  host: 'prod-mariadb.ckzduimfmpdl.us-west-2.rds.amazonaws.com'
});




module.exports = sequelize;