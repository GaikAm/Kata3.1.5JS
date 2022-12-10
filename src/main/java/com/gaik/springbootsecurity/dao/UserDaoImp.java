package com.gaik.springbootsecurity.dao;


import com.gaik.springbootsecurity.model.Role;
import com.gaik.springbootsecurity.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Repository
public class UserDaoImp implements UserDao {


    PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @PersistenceContext
    private EntityManager em;

    @Override
    public void saveUser(User user) {
        System.out.println(user);
        if (user.getId() == null) {
            user.setPassword(passwordEncoder.encode(user.getPassword()));
            for (Role r: user.getRoles()) {
                em.merge(r);
            }
            em.persist(user);
        } else {
            if (user.getPassword() == "") {
                user.setPassword(findById(user.getId()).getPassword());
            } else {
                user.setPassword(passwordEncoder.encode(user.getPassword()));
            }

            if (user.getRoles() == null) {
                user.setRoles(findById(user.getId()).getRoles());
            }

            em.merge(user);
        }
        em.flush();
    }

    @Override
    public void removeUserById(long id) {
        em.createQuery("delete from User u where u.id = :id")
                .setParameter("id", id)
                .executeUpdate();
        em.flush();
    }

    @Override
    public List<User> getAllUsers() {
        return em.createQuery("SELECT u FROM User u", User.class).getResultList();
    }

    @Override
    public void updateUserById(long id, String firstName, String lastName,
                               byte age, String email, String password, List<Role> roles) {

        if (password == "") {
            password = findById(id).getPassword();
        } else {
            password = passwordEncoder.encode(password);
        }
        User user = new User(password, firstName, lastName, age, email, roles);
        user.setId(id);

        em.merge(user);

        em.flush();
    }

    @Override
    public User findByUsername(String username) {
        return em.createQuery("SELECT u FROM User u JOIN FETCH u.roles r WHERE u.email=:username", User.class)
                .setParameter("username", username)
                .getSingleResult();
    }

    @Override
    public User findById(long id) {
        return em.createQuery("SELECT u FROM User u WHERE u.id=:id", User.class)
                .setParameter("id", id)
                .getSingleResult();
    }

    @Override
    public Set<Role> getRoles() {
        return new HashSet<>(em.createQuery("SELECT r FROM Role r", Role.class).getResultList());
    }
}
