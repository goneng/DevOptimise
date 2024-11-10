# Add User to Group <!-- omit in toc -->

A safe way to add a user to a group\
(without losing membership in other groups)

(from [AskUbuntu: How to add existing user to an existing group?](https://askubuntu.com/a/79566/138065))

### Table of Contents <!-- omit in toc -->
- [List the Current Groups of the User](#list-the-current-groups-of-the-user)
- [Enlist the User as Part of the Group](#enlist-the-user-as-part-of-the-group)
- [Confirm Noting was Lost](#confirm-noting-was-lost)


## List the Current Groups of the User

```bash
id -nG
```

## Enlist the User as Part of the Group

```bash
sudo usermod -a -G <group-name> <user-name>
```

## Confirm Noting was Lost

- Open a new Login-shell

    ```bash
    sudo login -f <user-name>
    ```

- List your groups and compare the list to the original one

    ```bash
    id -nG
    ```

- If you have lost any groups, review your work and fix as needed\
    (may need to enroll in the missing groups one-by-one)
