package com.gaik.springbootsecurity.controller;

import com.gaik.springbootsecurity.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;

@Controller
public class UserController {

    @Autowired
    UserService userService;
    PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
}
