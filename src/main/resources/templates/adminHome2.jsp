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
            <div id="AdminNav"></div>
            <div id="UserNav"></div>
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
                        <div id="editFormModal"></div>
                        <div id="deleteFormModal"></div>
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

                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type = "text/javascript">
    "use strict";

    let roles;
    let htmlAllRoles = "";
    let htmlRoles = "";
    {
        let nOfRows;
        let json;
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
            createTable(json, nOfRows);
            createNewUserForm();
        });
    }


    function getEditFormModal(dataId) {
        fetch('/api/admin/' + dataId
        ).then(response => response.json()
        ).then(data => {
            console.log(data);
            document.querySelector("#editFormModal").innerHTML = `
                    <div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
                            <form class="formEdit" method="post">

                            </form>
                        </div>
                    </div>`;
            document.querySelector(`.formEdit`).innerHTML = `
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="editUserLongTitle">Edit user</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">

                                        <input type="hidden" name="id" value="${data.id}" readonly>

                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>ID</strong></h6>
                                            <input type="text" value="${data.id}" class="form-control" disabled>
                                        </div>
                                        <br>
                                        <div id="divFirstName${data.id}" class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>First name</strong></h6>
                                            <input type="text" name="firstName" value="${data.firstName}" class="form-control" placeholder="Имя" maxlength="45" required>
                                        </div>
                                        <br>
                                        <div id="divLastName${data.id}" class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Last name</strong></h6>
                                            <input type="text" name="lastName" value="${data.lastName}" class="form-control" placeholder="Фамилия" maxlength="45" required>
                                        </div>
                                        <br>
                                        <div id="divAge${data.id}" class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Age</strong></h6>
                                            <input type="number" name="age" value="${data.age}" class="form-control" placeholder="Возраст" max="110" min="0" required>
                                        </div>
                                        <br>
                                        <div id="divEmail${data.id}" class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Email</strong></h6>
                                            <input type="text" name="email" value="${data.email}" class="form-control" placeholder="Email" maxlength="45" required>
                                        </div>
                                        <br>
                                        <div id="divPassword${data.id}" class="form-group mx-auto" style="width: 250px;">
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
                                        <input id="subForm" type="submit" value="Edit" class="btn btn-primary">
                                    </div>
                                </div>`;
            document.querySelector(`.formEdit`).addEventListener('submit', editUserInTable);
            $("#editModal").modal();
        });
    }

    function getDeleteFormModal(dataId) {
        fetch('/api/admin/' + dataId
        ).then(response => response.json()
        ).then(data => {
            console.log(data);
            document.querySelector("#deleteFormModal").innerHTML = `
                    <div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
                            <form class="formDelete" method="post">

                            </form>
                        </div>
                    </div>`;
            document.querySelector(`.formDelete`).innerHTML = `
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="exampleModalLongTitle">Delete user</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">

                                        <input type="hidden" name="id" value="${data.id}" readonly>

                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>ID</strong></h6>
                                            <input type="text" value="${data.id}" class="form-control" disabled>
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>First name</strong></h6>
                                            <input type="text" value="${data.firstName}" class="form-control" disabled required>
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Last name</strong></h6>
                                            <input type="text" value="${data.lastName}" class="form-control" disabled required>
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Age</strong></h6>
                                            <input type="number" value="${data.age}" class="form-control" disabled required>
                                        </div>
                                        <br>
                                        <div class="form-group mx-auto" style="width: 250px;">
                                            <h6 class="text-center"><strong>Email</strong></h6>
                                            <input type="text" value="${data.email}" class="form-control" disabled required>
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
                                        <input id="subDelete${data.id}" type="submit" value="Delete" class="btn btn-danger">
                                    </div>
                                </div>`;
            document.querySelector(`.formDelete`).addEventListener('submit', deleteUserInTable);
            $("#deleteModal").modal();
        });
    }

    function createNewUserInTable(data) {
        htmlRoles = "";
        for (let i = 0; i < data.roles.length; i++) {
            htmlRoles = htmlRoles + "<div>" + data.roles[i].name + "</div>";
        }
        if (!document.querySelector(`.subBody${data.id}`)) {
            document.querySelector(".body").innerHTML += `<tr class='subBody${data.id}'></tr>`;
        }
        document.querySelector(`.subBody${data.id}`).innerHTML = `
                    <td class="id${data.id}">${data.id}</td>
                    <td class="firstName${data.id}">${data.firstName}</td>
                    <td class="lastName${data.id}">${data.lastName}</td>
                    <td class="age${data.id}">${data.age}</td>
                    <td class="email${data.id}">${data.email}</td>
                    <td class="htmlRoles${data.id}">${htmlRoles}</td>
                    <td><button type="button" class="btn btn-info" onclick="getEditFormModal(${data.id})">
                        Edit</button></td>
                    <td><button type="button" class="btn btn-danger" onclick="getDeleteFormModal(${data.id})">
                        Delete</button></td>`;
    }

    async function onclickNewUserForm(event) {
        event.preventDefault();
        let form = document.querySelector(`#formNewUser`);
        let formData = new FormData(form);

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
            createNewUserInTable(newUser);
            createNewUserForm();
        });
    }

    function createNewUserForm() {
        document.querySelector('#formNewUser').innerHTML = `
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
        document.querySelector("#rolesInFormNewUser").innerHTML = `${htmlAllRoles}`;
        document.querySelector(`#formNewUser`).addEventListener('submit', onclickNewUserForm);
    }

    function createPanel() {
        fetch("/api/user").then(response => response.json()
        ).then(thisUser => {
            let htmlRoleNavbar = "";
            let roleThisUser = thisUser.roles;
            for (let i = 0; i < roleThisUser.length; i++) {
                if (roleThisUser[i].name == "ROLE_ADMIN") {
                    document.querySelector("#AdminNav").innerHTML = `
                    <li class="nav-item">
                        <a class="nav-link active" href="/admin">Admin</a>
                    </li>`;
                }

                if (roleThisUser[i].name == "ROLE_USER") {
                    document.querySelector("#UserNav").innerHTML = `
                    <li class="nav-item">
                        <a class="nav-link" href="/user">User</a>
                    </li>`;
                }

                htmlRoleNavbar += `${roleThisUser[i].name} `;
            }
            document.querySelector("#headNavbar").innerHTML = `${thisUser.email}`;
            document.querySelector("#roleNavbar").innerHTML = `${htmlRoleNavbar}`;
        });
    }

    async function editUserInTable(event) {
        event.preventDefault();
        console.log(event.path[0]);
        let form = event.path[0];
        let formData = new FormData(form);

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
            createNewUserInTable(editUser);
            document.querySelector("#editModal").remove();
            document.querySelector('#headBody').className = "";
            document.querySelector(".modal-backdrop").remove();
        });

    }

    async function deleteUserInTable(event) {
        event.preventDefault();
        let form = event.path[0];
        let formData = new FormData(form);
        let deleteId = formData.get("id");
        fetch("/api/admin", {
            method: "DELETE",
            body: `id=${deleteId}`,
            headers: {'Content-Type': 'application/x-www-form-urlencoded'}
        }).then(response => response.json()
        ).then(newJson => {
            document.querySelector(`.subBody${deleteId}`).remove();
            document.querySelector("#deleteModal").remove();
            document.querySelector("#headBody").className = "";
            document.querySelector(".modal-backdrop").remove();
        });
    }

    function createTable(data, nOfRows) {
        document.querySelector(".userTable").innerHTML = "<table class='table table-striped' id='tbl'></table>";
        document.querySelector("#tbl").innerHTML = `<thead class='head'></thead>
                                                    <tbody class='body'></tbody>`;

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
                createNewUserInTable(data[i]);
            }
        }
    }
</script>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js" integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</body>
</html>