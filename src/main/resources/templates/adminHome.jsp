<input type="hidden" <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<input type="hidden" <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>UsersTable</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
</head>
<body id="headBody">

<nav class="navbar navbar-dark bg-dark">
    <div>
        <span id="headNavbar" class="navbar-brand h1 px-md-3">Navbar</span>
        <span class="navbar-text">with roles: </span>
        <span id="roleNavbar" class="navbar-text">Navbar</span>
    </div>
    <a class="navbar-text px-md-3" href="/logout">Logout</a>
</nav>

<div class="row no-gutters">
    <div class="col-2">
        <br>
        <ul id="navPanel" class="nav flex-column nav-pills" aria-orientation="vertical">

        </ul>
    </div>
    <div class="col-10 bg-light px-md-5">
        <br>
        <h1>Admin panel</h1>
        <br>
        <ul class="nav nav-tabs" id="myTab" role="tablist">
            <li class="nav-item">
                <a class="nav-link active" id="users-table" data-toggle="tab" href="#usersTable" role="tab" aria-controls="usersTable" aria-selected="true">Users Table</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" id="new-user" data-toggle="tab" href="#newUser" role="tab" aria-controls="newUser" aria-selected="false">New User</a>
            </li>
        </ul>
        <div class="tab-content" id="myTabContent">
            <div class="tab-pane fade show active" id="usersTable" role="tabpanel" aria-labelledby="users-table">
                <div class="card">
                    <div class="card-header">
                        <h4>All users</h4>
                    </div>
                    <div class="card-body">
                        <div class="userTable"></div>
                    </div>
                </div>
            </div>
            <div class="tab-pane fade" id="newUser" role="tabpanel" aria-labelledby="new-user">
                <div class="card">
                    <div class="card-header">
                        <h4>Add new user</h4>
                    </div>
                    <div class="card-body">
                        <form id="formNewUser" method="post">
                            <div id="divNewFirstName" class="form-group mx-auto" style="width: 250px;">
                                <h6 class="text-center"><strong>First name</strong></h6>
                                <input type="text" name="firstName" class="form-control" placeholder="Имя" maxlength="45" required>
                            </div>
                            <br>
                            <div id="divNewLastName" class="form-group mx-auto" style="width: 250px;">
                                <h6 class="text-center"><strong>Last name</strong></h6>
                                <input type="text" name="lastName" class="form-control" placeholder="Фамилия" maxlength="45" required>
                            </div>
                            <br>
                            <div id="divNewAge" class="form-group mx-auto" style="width: 250px;">
                                <h6 class="text-center"><strong>Age</strong></h6>
                                <input type="number" name="age" class="form-control" placeholder="Возраст" max="110" min="0" required>
                            </div>
                            <br>
                            <div id="divNewEmail" class="form-group mx-auto" style="width: 250px;">
                                <h6 class="text-center"><strong>Email</strong></h6>
                                <input type="text" name="email" class="form-control" placeholder="Email" maxlength="45" required>
                            </div>
                            <br>
                            <div id="divNewPassword" class="form-group mx-auto" style="width: 250px;">
                                <h6 class="text-center"><strong>Password</strong></h6>
                                <input type="password" name="password" class="form-control" placeholder="Пароль" maxlength="45" required>
                            </div>
                            <br>
                            <div id="divNewRoleNewUser" class="form-group mx-auto" style="width: 250px;">
                                <h6 class="text-center"><strong>Role</strong></h6>
                                <select id="rolesInFormNewUser" name="roleNewUser" multiple class="form-control" size="2" required>

                                </select>
                            </div>
                            <br>
                            <div class="form-group text-center mx-auto" style="width: 250px;">
                                <input id="subNewUser" type="submit" value="Add new user" class="btn btn-success btn-lg">
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type = "text/javascript">
    "use strict";
    let table;
    let nOfRows;
    let json;
    let roles;
    let htmlAllRoles = "";
    let htmlRoles = "";
    fetch("/api/admin").then(response => {
        return response.json();
    }).then(data2 => {
        json = data2;
        nOfRows = json.length;
        return fetch("/api/roles")
    }).then(response => {
        return response.json();
    }).then(data2 => {
        roles = data2;
        for (let i = 0; i < roles.length; i++) {
            htmlAllRoles = htmlAllRoles + `<option value="${roles[i].name}">${roles[i].name}</option>`;
        }

        createPanel();
        createTable(json);
        createNewUserForm();
    });

    function createNewUserInTable(event) {
        event.preventDefault();
        let form = document.querySelector(`#formNewUser`);
        let formData = new FormData(form);


        if (formData.get("firstName").length < 3 || formData.get("firstName").length > 45) {
            if (!document.querySelector(`#smallNewFirstName`)) {
                document.querySelector(`#divNewFirstName`).innerHTML += `
                <small id="smallNewFirstName" class="form-text text-muted">Кол-во символов должно быть от 3 до 45.</small>`
            }
        } else if (formData.get("lastName").length < 3 || formData.get("lastName").length > 45) {
            if (!document.querySelector(`#smallNewLastName`)) {
                document.querySelector(`#divNewLastName`).innerHTML += `
                <small id="smallNewLastName" class="form-text text-muted">Кол-во символов должно быть от 3 до 45.</small>`
            }
        } else if (formData.get("age") < 0 || formData.get("age") > 110 || formData.get("age") == "") {
            if (!document.querySelector(`#smallNewAge`)) {
                document.querySelector(`#divNewAge`).innerHTML += `
                <small id="smallNewAge" class="form-text text-muted">Введите значение от 0 до 110.</small>`
            }
        } else if (formData.get("email").length < 9 || formData.get("email").length > 45) {
            if (!document.querySelector(`#smallNewEmail`)) {
                document.querySelector(`#divNewEmail`).innerHTML += `
                <small id="smallNewEmail" class="form-text text-muted">Кол-во символов должно быть от 9 до 45.</small>`
            }
        } else if (formData.get("password").length < 3 || formData.get("password").length > 45) {
            if (!document.querySelector(`#smallNewPassword`)) {
                document.querySelector(`#divNewPassword`).innerHTML += `
                <small id="smallNewPassword" class="form-text text-muted">Кол-во символов должно быть от 3 до 45.</small>`
            }
        } else if (formData.getAll("roleNewUser").length < 1) {
            if (!document.querySelector(`#smallNewRoleNewUser`)) {
                document.querySelector(`#divNewRoleNewUser`).innerHTML += `
                <small id="smallNewRoleNewUser" class="form-text text-muted">Выберите хотя бы одну роль.</small>`
            }
        } else {
            console.log(formData.getAll("roleNewUser").length);
            let body = `firstName=${formData.get("firstName")}&lastName=${formData.get("lastName")}&age=${formData.get("age")}&email=${formData.get("email")}&password=${formData.get("password")}&roleNewUser=`;
            let roleNewUser = formData.getAll("roleNewUser");
            for (let k = 0; k < roleNewUser.length; k++) {
                body = body + `${roleNewUser[k]},`;
            }

            fetch("/api/admin", {
                method: "POST",
                body: body,
                headers: {'Content-Type': 'application/x-www-form-urlencoded'}
            }).then(response => response.json()
            ).then(newUser => {
                htmlRoles = "";
                for (let j = 0; j < newUser.roles.length; j++) {
                    htmlRoles = htmlRoles + "<div>" + newUser.roles[j].name + "</div>";
                }
                document.querySelector(".body").innerHTML = document.querySelector(".body").innerHTML + `
                <tr class='subBody${newUser.id}'></tr>`;

                document.querySelector(`.subBody${newUser.id}`).innerHTML = `
                    <td class="id${newUser.id}">${newUser.id}</td>
                    <td class="firstName${newUser.id}">${newUser.firstName}</td>
                    <td class="lastName${newUser.id}">${newUser.lastName}</td>
                    <td class="age${newUser.id}">${newUser.age}</td>
                    <td class="email${newUser.id}">${newUser.email}</td>
                    <td class="htmlRoles${newUser.id}">${htmlRoles}</td>
                    <td><button type="button" class="btn btn-info" data-toggle="modal" data-target="${'#editModal' + newUser.id}">
                        Edit</button></td>
                    <td><button type="button" class="btn btn-danger" data-toggle="modal" data-target="${'#deleteModal' + newUser.id}">
                        Delete</button></td>
                    <div class="modal fade" id="${'editModal' + newUser.id}" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
                            <form class="${'formEdit' + newUser.id}" method="post" object="${newUser}">

                            </form>
                        </div>
                    </div>

                    <div class="modal fade" id="${'deleteModal' + newUser.id}" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
                            <form class="${'formDelete' + newUser.id}" method="post" action="/admin/delete">

                            </form>
                        </div>
                    </div>`;
                document.querySelector(`.formEdit${newUser.id}`).innerHTML = `
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="editUserLongTitle">Edit user</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">

                                        <input type="hidden" name="id" value="${newUser.id}" readonly>

                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>ID</strong></h6>
                                            <input type="text" value="${newUser.id}" class="form-control" disabled>
                                        </div>
                                        <br>
                                        <div id="divFirstName${newUser.id}" class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>First name</strong></h6>
                                            <input type="text" name="firstName" value="${newUser.firstName}" class="form-control" placeholder="Имя" maxlength="45" required>
                                        </div>
                                        <br>
                                        <div id="divLastName${newUser.id}" class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Last name</strong></h6>
                                            <input type="text" name="lastName" value="${newUser.lastName}" class="form-control" placeholder="Фамилия" maxlength="45" required>
                                        </div>
                                        <br>
                                        <div id="divAge${newUser.id}" class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Age</strong></h6>
                                            <input type="number" name="age" value="${newUser.age}" class="form-control" placeholder="Возраст" max="110" min="0" required>
                                        </div>
                                        <br>
                                        <div id="divEmail${newUser.id}" class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Email</strong></h6>
                                            <input type="text" name="email" value="${newUser.email}" class="form-control" placeholder="Email" maxlength="45" required>
                                        </div>
                                        <br>
                                        <div id="divPassword${newUser.id}" class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Password</strong></h6>
                                            <input type="password" name="password" class="form-control" placeholder="Пароль" maxlength="45">
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Role</strong></h6>
                                            <select name="roleNewUser" multiple class="form-control" size="2">
                                                <option value="" selected hidden>Выберите роль</option>
                                                ${htmlAllRoles}
                                            </select>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                        <input id="subForm${newUser.id}" type="submit" value="Edit" class="btn btn-primary">
                                    </div>
                                </div>`;
                document.querySelector(`#subForm${newUser.id}`).onclick = editUserInTable;
                document.querySelector(`.formDelete${newUser.id}`).innerHTML = `
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="exampleModalLongTitle">Delete user</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">

                                        <input type="hidden" name="id" value="${newUser.id}" readonly>

                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>ID</strong></h6>
                                            <input type="text" value="${newUser.id}" class="form-control" disabled>
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>First name</strong></h6>
                                            <input type="text" value="${newUser.firstName}" class="form-control" disabled required>
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Last name</strong></h6>
                                            <input type="text" value="${newUser.lastName}" class="form-control" disabled required>
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Age</strong></h6>
                                            <input type="number" value="${newUser.age}" class="form-control" disabled required>
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Email</strong></h6>
                                            <input type="text" value="${newUser.email}" class="form-control" disabled required>
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Role</strong></h6>
                                            <select multiple class="form-control" size="2" disabled>
                                                ${htmlAllRoles}
                                            </select>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                        <input id="subDelete${newUser.id}" type="submit" value="Delete" class="btn btn-danger">
                                    </div>
                                </div>`;
                document.querySelector(`#subDelete${newUser.id}`).onclick = deleteUserInTable;

                document.querySelector(`#formNewUser`).innerHTML = `
                            <div id="divNewFirstName" class="form-group mx-auto" style="width: 250px;">
                                <h6 class="text-center"><strong>First name</strong></h6>
                                <input type="text" name="firstName" class="form-control" placeholder="Имя" maxlength="45" required>
                            </div>
                            <br>
                            <div id="divNewLastName" class="form-group mx-auto" style="width: 250px;">
                                <h6 class="text-center"><strong>Last name</strong></h6>
                                <input type="text" name="lastName" class="form-control" placeholder="Фамилия" maxlength="45" required>
                            </div>
                            <br>
                            <div id="divNewAge" class="form-group mx-auto" style="width: 250px;">
                                <h6 class="text-center"><strong>Age</strong></h6>
                                <input type="number" name="age" class="form-control" placeholder="Возраст" max="110" min="0" required>
                            </div>
                            <br>
                            <div id="divNewEmail" class="form-group mx-auto" style="width: 250px;">
                                <h6 class="text-center"><strong>Email</strong></h6>
                                <input type="text" name="email" class="form-control" placeholder="Email" maxlength="45" required>
                            </div>
                            <br>
                            <div id="divNewPassword" class="form-group mx-auto" style="width: 250px;">
                                <h6 class="text-center"><strong>Password</strong></h6>
                                <input type="password" name="password" class="form-control" placeholder="Пароль" maxlength="45" required>
                            </div>
                            <br>
                            <div id="divNewRoleNewUser" class="form-group mx-auto" style="width: 250px;">
                                <h6 class="text-center"><strong>Role</strong></h6>
                                <select id="rolesInFormNewUser" name="roleNewUser" multiple class="form-control" size="2" required>

                                </select>
                            </div>
                            <br>
                            <div class="form-group text-center mx-auto" style="width: 250px;">
                                <input id="subNewUser" type="submit" value="Add new user" class="btn btn-success btn-lg">
                            </div>`;
                createNewUserForm();

                fetch("/api/admin").then(response => {
                    return response.json();
                }).then(data2 => {
                    json = data2;
                    nOfRows = json.length;
                });
            });
        }
    }

    function createNewUserForm() {
        document.querySelector("#rolesInFormNewUser").innerHTML = `${htmlAllRoles}`;
        document.querySelector(`#subNewUser`).onclick = createNewUserInTable;
    }

    function createPanel() {
        fetch("/api/user").then(response => response.json()
        ).then(thisUser => {
            let htmlPanel = "";
            let htmlRoleNavbar = "";
            let roleThisUser = thisUser.roles;
            for (let i = 0; i < roleThisUser.length; i++) {
                if (roleThisUser[i].name == "ROLE_ADMIN") {
                    htmlPanel = htmlPanel + `
                    <li class="nav-item">
                        <a class="nav-link active" href="/admin">Admin</a>
                    </li>`;
                }

                if (roleThisUser[i].name == "ROLE_USER") {
                    htmlPanel = htmlPanel + `
                    <li class="nav-item">
                        <a class="nav-link" href="/user">User</a>
                    </li>`;
                }

                htmlRoleNavbar += `${roleThisUser[i].name} `;
            }
            document.querySelector("#navPanel").innerHTML = htmlPanel;
            document.querySelector("#headNavbar").innerHTML = `${thisUser.email}`;
            document.querySelector("#roleNavbar").innerHTML = `${htmlRoleNavbar}`;
        });
    }

    function editUserInTable(event) {
        event.preventDefault();
        let thisId = 0 + +(event.path[0].id.slice(7));
        let form = document.querySelector(`.formEdit${thisId}`);
        let formData = new FormData(form);

        if (formData.get("firstName").length < 3 || formData.get("firstName").length > 45) {
            if (!document.querySelector(`#smallFirstName`)) {
                document.querySelector(`#divFirstName${thisId}`).innerHTML += `
                <small id="smallFirstName" class="form-text text-muted">Кол-во символов должно быть от 3 до 45.</small>`
            }
        } else if (formData.get("lastName").length < 3 || formData.get("lastName").length > 45) {
            if (!document.querySelector(`#smallLastName`)) {
                document.querySelector(`#divLastName${thisId}`).innerHTML += `
                <small id="smallLastName" class="form-text text-muted">Кол-во символов должно быть от 3 до 45.</small>`
            }
        } else if (formData.get("age") < 0 || formData.get("age") > 110 || formData.get("age") == "") {
            if (!document.querySelector(`#smallAge`)) {
                document.querySelector(`#divAge${thisId}`).innerHTML += `
                <small id="smallAge" class="form-text text-muted">Введите значение от 0 до 110.</small>`
            }
        } else if (formData.get("email").length < 9 || formData.get("email").length > 45) {
            if (!document.querySelector(`#smallEmail`)) {
                document.querySelector(`#divEmail${thisId}`).innerHTML += `
                <small id="smallEmail" class="form-text text-muted">Кол-во символов должно быть от 9 до 45.</small>`
            }
        } else if (formData.get("password").length > 45) {
            if (!document.querySelector(`#smallPassword`)) {
                document.querySelector(`#divPassword${thisId}`).innerHTML += `
                <small id="smallPassword" class="form-text text-muted">Кол-во символов должно быть от 0 до 45.<br>
                                                                       0 - не изменять пароль.</small>`
            }
        } else {
            console.log(formData.get("age"));
            let body = `id=${formData.get("id")}&firstName=${formData.get("firstName")}&lastName=${formData.get("lastName")}&age=${formData.get("age")}&email=${formData.get("email")}&password=${formData.get("password")}&roleNewUser=`;
            let roleNewUser = formData.getAll("roleNewUser");
            for (let k = 0; k < roleNewUser.length; k++) {
                body = body + `${roleNewUser[k]},`;
            }

            fetch("/api/admin", {
                method: "POST",
                body: body,
                headers: {'Content-Type': 'application/x-www-form-urlencoded'}
            }).then(response => response.json()
            ).then(editUser => {
                htmlRoles = "";
                for (let j = 0; j < editUser.roles.length; j++) {
                    htmlRoles = htmlRoles + "<div>" + editUser.roles[j].name + "</div>";
                }
                document.querySelector(`.subBody${editUser.id}`).innerHTML = `
                    <td class="id${editUser.id}">${editUser.id}</td>
                    <td class="firstName${editUser.id}">${editUser.firstName}</td>
                    <td class="lastName${editUser.id}">${editUser.lastName}</td>
                    <td class="age${editUser.id}">${editUser.age}</td>
                    <td class="email${editUser.id}">${editUser.email}</td>
                    <td class="htmlRoles${editUser.id}">${htmlRoles}</td>
                    <td><button type="button" class="btn btn-info" data-toggle="modal" data-target="${'#editModal' + editUser.id}">
                        Edit</button></td>
                    <td><button type="button" class="btn btn-danger" data-toggle="modal" data-target="${'#deleteModal' + editUser.id}">
                        Delete</button></td>
                    <div class="modal fade" id="${'editModal' + editUser.id}" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
                            <form class="${'formEdit' + editUser.id}" method="post" object="${editUser}">

                            </form>
                        </div>
                    </div>

                    <div class="modal fade" id="${'deleteModal' + editUser.id}" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
                            <form class="${'formDelete' + editUser.id}" method="post" action="/admin/delete">

                            </form>
                        </div>
                    </div>`;
                document.querySelector(`.formEdit${editUser.id}`).innerHTML = `
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="editUserLongTitle">Edit user</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">

                                        <input type="hidden" name="id" value="${editUser.id}" readonly>

                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>ID</strong></h6>
                                            <input type="text" value="${editUser.id}" class="form-control" disabled>
                                        </div>
                                        <br>
                                        <div id="divFirstName${editUser.id}" class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>First name</strong></h6>
                                            <input type="text" name="firstName" value="${editUser.firstName}" class="form-control" placeholder="Имя" maxlength="45" required>
                                        </div>
                                        <br>
                                        <div id="divLastName${editUser.id}" class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Last name</strong></h6>
                                            <input type="text" name="lastName" value="${editUser.lastName}" class="form-control" placeholder="Фамилия" maxlength="45" required>
                                        </div>
                                        <br>
                                        <div id="divAge${editUser.id}" class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Age</strong></h6>
                                            <input type="number" name="age" value="${editUser.age}" class="form-control" placeholder="Возраст" max="110" min="0" required>
                                        </div>
                                        <br>
                                        <div id="divEmail${editUser.id}" class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Email</strong></h6>
                                            <input type="text" name="email" value="${editUser.email}" class="form-control" placeholder="Email" maxlength="45" required>
                                        </div>
                                        <br>
                                        <div id="divPassword${editUser.id}" class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Password</strong></h6>
                                            <input type="password" name="password" class="form-control" placeholder="Пароль" maxlength="45">
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Role</strong></h6>
                                            <select name="roleNewUser" multiple class="form-control" size="2">
                                                <option value="" selected hidden>Выберите роль</option>
                                                ${htmlAllRoles}
                                            </select>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                        <input id="subForm${editUser.id}" type="submit" value="Edit" class="btn btn-primary">
                                    </div>
                                </div>`;
                document.querySelector(`#subForm${editUser.id}`).onclick = editUserInTable;
                document.querySelector(`.formDelete${editUser.id}`).innerHTML = `
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="exampleModalLongTitle">Delete user</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">

                                        <input type="hidden" name="id" value="${editUser.id}" readonly>

                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>ID</strong></h6>
                                            <input type="text" value="${editUser.id}" class="form-control" disabled>
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>First name</strong></h6>
                                            <input type="text" value="${editUser.firstName}" class="form-control" disabled required>
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Last name</strong></h6>
                                            <input type="text" value="${editUser.lastName}" class="form-control" disabled required>
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Age</strong></h6>
                                            <input type="number" value="${editUser.age}" class="form-control" disabled required>
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Email</strong></h6>
                                            <input type="text" value="${editUser.email}" class="form-control" disabled required>
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Role</strong></h6>
                                            <select multiple class="form-control" size="2" disabled>
                                                ${htmlAllRoles}
                                            </select>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                        <input id="subDelete${editUser.id}" type="submit" value="Delete" class="btn btn-danger">
                                    </div>
                                </div>`;
                document.querySelector(`#subDelete${editUser.id}`).onclick = deleteUserInTable;
                document.querySelector("#headBody").className = "";
                document.querySelector(".modal-backdrop").remove();
            });
        }
    }

    function deleteUserInTable(event) {
        event.preventDefault();
        let thisId = 0 + +(event.path[0].id.slice(9));
        let form = document.querySelector(`.formDelete${thisId}`);
        let formData = new FormData(form);
        let deleteId = formData.get("id");
        fetch("/api/admin", {
            method: "DELETE",
            body: `id=${deleteId}`,
            headers: {'Content-Type': 'application/x-www-form-urlencoded'}
        }).then(response => response.json()
        ).then(newJson => {
            json = newJson;
            nOfRows = json.length;
            document.querySelector(`.subBody${deleteId}`).remove();
            document.querySelector("#headBody").className = "";
            document.querySelector(".modal-backdrop").remove();
        });
    }

    function createTable(data) {
        let newUser = {};
        document.querySelector(".userTable").innerHTML = "<table class='table table-striped' id='tbl'></table>";
        document.querySelector("#tbl").innerHTML = `<thead class='head'></thead>
                                                    <tbody class='body'></tbody>`;
        let allTd = "";
        for (let i = -1; i < nOfRows; i++) {
            if (i == -1) {
                document.querySelector(".head").innerHTML = "<tr class='subHead'></tr>";
                document.querySelector(".subHead").innerHTML = `
                    <th scope='col'>ID</th>
                    <th scope='col'>FirstName</th>
                    <th scope='col'>LastName</th>
                    <th scope='col'>Age</th>
                    <th scope='col'>Email</th>
                    <th scope='col'>Role</th>
                    <th scope='col'>Edit</th>
                    <th scope='col'>Delete</th>`;
            } else {
                allTd = allTd + `<tr class='subBody${data[i].id}'></tr>`;
            }
        }
        document.querySelector(".body").innerHTML = allTd;
        for (let i = 0; i < nOfRows; i++) {
            htmlRoles = "";
            for (let j = 0; j < data[i].roles.length; j++) {
                htmlRoles = htmlRoles + "<div>" + data[i].roles[j].name + "</div>";
            }
            document.querySelector(`.subBody${data[i].id}`).innerHTML = `
                    <td class="id${data[i].id}">${data[i].id}</td>
                    <td class="firstName${data[i].id}">${data[i].firstName}</td>
                    <td class="lastName${data[i].id}">${data[i].lastName}</td>
                    <td class="age${data[i].id}">${data[i].age}</td>
                    <td class="email${data[i].id}">${data[i].email}</td>
                    <td class="htmlRoles${data[i].id}">${htmlRoles}</td>
                    <td><button type="button" class="btn btn-info" data-toggle="modal" data-target="${'#editModal' + data[i].id}">
                        Edit</button></td>
                    <td><button type="button" class="btn btn-danger" data-toggle="modal" data-target="${'#deleteModal' + data[i].id}">
                        Delete</button></td>
                    <div class="modal fade" id="${'editModal' + data[i].id}" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
                            <form class="${'formEdit' + data[i].id}" method="post" object="${newUser}">

                            </form>
                        </div>
                    </div>

                    <div class="modal fade" id="${'deleteModal' + data[i].id}" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
                            <form class="${'formDelete' + data[i].id}" method="post">

                            </form>
                        </div>
                    </div>`;
            document.querySelector(`.formEdit${data[i].id}`).innerHTML = `
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="editUserLongTitle">Edit user</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">

                                        <input type="hidden" name="id" value="${data[i].id}" readonly>

                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>ID</strong></h6>
                                            <input type="text" value="${data[i].id}" class="form-control" disabled>
                                        </div>
                                        <br>
                                        <div id="divFirstName${data[i].id}" class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>First name</strong></h6>
                                            <input type="text" name="firstName" value="${data[i].firstName}" class="form-control" placeholder="Имя" maxlength="45" required>
                                        </div>
                                        <br>
                                        <div id="divLastName${data[i].id}" class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Last name</strong></h6>
                                            <input type="text" name="lastName" value="${data[i].lastName}" class="form-control" placeholder="Фамилия" maxlength="45" required>
                                        </div>
                                        <br>
                                        <div id="divAge${data[i].id}" class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Age</strong></h6>
                                            <input type="number" name="age" value="${data[i].age}" class="form-control" placeholder="Возраст" max="110" min="0" required>
                                        </div>
                                        <br>
                                        <div id="divEmail${data[i].id}" class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Email</strong></h6>
                                            <input type="text" name="email" value="${data[i].email}" class="form-control" placeholder="Email" maxlength="45" required>
                                        </div>
                                        <br>
                                        <div id="divPassword${data[i].id}" class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Password</strong></h6>
                                            <input type="password" name="password" class="form-control" placeholder="Пароль" maxlength="45">
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Role</strong></h6>
                                            <select name="roleNewUser" multiple class="form-control" size="2">
                                                <option value="" selected hidden>Выберите роль</option>
                                                ${htmlAllRoles}
                                            </select>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                        <input id="subForm${data[i].id}" type="submit" value="Edit" class="btn btn-primary">
                                    </div>
                                </div>`;
            document.querySelector(`#subForm${data[i].id}`).onclick = editUserInTable;
            document.querySelector(`.formDelete${data[i].id}`).innerHTML = `
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="exampleModalLongTitle">Delete user</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">

                                        <input type="hidden" name="id" value="${data[i].id}" readonly>

                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>ID</strong></h6>
                                            <input type="text" value="${data[i].id}" class="form-control" disabled>
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>First name</strong></h6>
                                            <input type="text" value="${data[i].firstName}" class="form-control" disabled required>
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Last name</strong></h6>
                                            <input type="text" value="${data[i].lastName}" class="form-control" disabled required>
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Age</strong></h6>
                                            <input type="number" value="${data[i].age}" class="form-control" disabled required>
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Email</strong></h6>
                                            <input type="text" value="${data[i].email}" class="form-control" disabled required>
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Role</strong></h6>
                                            <select multiple class="form-control" size="2" disabled>
                                                ${htmlAllRoles}
                                            </select>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                        <input id="subDelete${data[i].id}" type="submit" value="Delete" class="btn btn-danger">
                                    </div>
                                </div>`;
            document.querySelector(`#subDelete${data[i].id}`).onclick = deleteUserInTable;

        }
        //table = document.getElementById("tbl");
    }
</script>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</body>
</html>