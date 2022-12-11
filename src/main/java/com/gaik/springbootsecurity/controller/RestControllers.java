package com.gaik.springbootsecurity.controller;

import com.gaik.springbootsecurity.model.Role;
import com.gaik.springbootsecurity.model.User;
import com.gaik.springbootsecurity.service.UserServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.*;


@RestController
@RequestMapping("/api")
public class RestControllers {

    @Autowired
    private UserServiceImp userServiceImp;

    @GetMapping(value = "/user")
    public User userData(Principal principal) {
        return userServiceImp.findByUsername(principal.getName());
    }

    @GetMapping("/roles")
    public List<Role> showAllRoles() {
        List<Role> roleList = new ArrayList<>(userServiceImp.getRoles());
        return roleList;
    }

    @GetMapping("/admin")
    public List<User> showAllUsers() {
        return userServiceImp.getAllUsers();
    }

    @GetMapping("/admin/{id}")
    public User getUserById(@PathVariable long id) {
        return userServiceImp.findById(id);
    }

    @PostMapping("/admin")
    public User addUser(@ModelAttribute("newUser") User newUser,
                        @RequestParam(name = "roleNewUser", required = false) List<String> roleNewUser) {
        Set<Role> roleSet = new HashSet<>();
        System.out.println(roleNewUser);
        for (String roleStr: roleNewUser) {
            try {
                roleSet.add(userServiceImp.getRoles()
                        .stream()
                        .filter(role -> role.getName().compareTo(roleStr) == 0)
                        .findFirst().get());
            } catch (NoSuchElementException e) {}
        }
        if (roleSet.isEmpty()) {
            roleSet = null;
        }
        newUser.setRoles(roleSet);
        userServiceImp.saveUser(newUser);
        return userServiceImp.findByUsername(newUser.getUsername());
    }

    @DeleteMapping(value = "/admin")
    public List<User> deleteUserById(@RequestParam(required = false) Long id) {
        if (id != null) {
            System.out.println(id);
            userServiceImp.removeUserById(id);
        }
        return userServiceImp.getAllUsers();
    }

}
