const Sequelize = require('sequelize');

const sequelize = require('../database');

const Student = sequelize.define('student', {
  id: {
    type: Sequelize.INTEGER,
    autoIncrement: true,
    primaryKey: true
  },
  first_name: Sequelize.STRING,
  last_name: Sequelize.STRING
});

module.exports = Student;
