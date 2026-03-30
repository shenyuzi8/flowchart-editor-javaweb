CREATE DATABASE IF NOT EXISTS diagram_sys;
USE diagram_sys;

CREATE TABLE user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL
);

CREATE TABLE diagram (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(200),
    type VARCHAR(20),
    content LONGTEXT,
    FOREIGN KEY (user_id) REFERENCES user(id)
);
