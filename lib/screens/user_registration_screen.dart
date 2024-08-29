import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_framework/responsive_row_column.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import '../models/user_models/add_user_model.dart';
import '../models/user_models/get_users_list_model.dart';
import '../models/user_models/update_user_model.dart';
import '../services/api_service.dart';
import '../services/api_urls.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_loader_indicator.dart';
import '../widgets/custom_table.dart';
import '../widgets/custom_text_field.dart';

class UserRegistrationForm extends StatefulWidget {
  const UserRegistrationForm({super.key});

  @override
  State<UserRegistrationForm> createState() => _UserRegistrationFormState();
}

class _UserRegistrationFormState extends State<UserRegistrationForm> {
  List<UsersList> usersList = [];
  List<UsersList> foundUsersList = [];

  bool _isLoading = false;

  var searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsersListApi();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  bool filterUsers(UsersList user, String query) {
    final lowerQuery = query.toLowerCase();
    return user.id.toString().toLowerCase().contains(lowerQuery) ||
        user.name.toLowerCase().contains(lowerQuery) ||
        user.role.toString().toLowerCase().contains(lowerQuery) ||
        user.phoneNumber.toLowerCase().contains(lowerQuery) ||
        user.vehicleNumber.toLowerCase().contains(lowerQuery) ||
        // user.address.toLowerCase().contains(lowerQuery) ||
        user.emailId.toLowerCase().contains(lowerQuery) ||
        user.joiningDate.toString().toLowerCase().contains(lowerQuery) ||
        (user.isDeleted.toString() == '0' ? 'yes' : 'no').contains(lowerQuery);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper.builder(
      Scaffold(
        appBar: AppBar(
          title: const Text('User List'),
        ),
        drawer: kIsWeb ? const CustomDrawer() : null,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _isLoading
              ? const LoaderIndicatorWidget(
                  message: 'Fetching Users please wait...',
                )
              : SingleChildScrollView(
                  child: CustomTable<UsersList>(
                    columns: const [
                      DataColumn(
                          label: Text('ID', style: TextStyle(fontSize: 14))),
                      DataColumn(
                          label:
                              Text('User ID', style: TextStyle(fontSize: 14))),
                      DataColumn(
                          label: Text('Name', style: TextStyle(fontSize: 14))),
                      DataColumn(
                          label: Text('Role', style: TextStyle(fontSize: 14))),
                      DataColumn(
                          label:
                              Text('Contact', style: TextStyle(fontSize: 14))),
                      DataColumn(
                          label: Text('Vehicle Number',
                              style: TextStyle(fontSize: 14))),
                      DataColumn(
                          label:
                              Text('Address', style: TextStyle(fontSize: 14))),
                      DataColumn(
                          label: Text('Email', style: TextStyle(fontSize: 14))),
                      DataColumn(
                          label: Text('Joined Date',
                              style: TextStyle(fontSize: 14))),
                      DataColumn(
                          label:
                              Text('Active', style: TextStyle(fontSize: 14))),
                    ],
                    rows: foundUsersList,
                    hasSearch: true,
                    dataCellBuilder: (user) => [
                      DataCell(Text(user.id.toString(),
                          style: const TextStyle(fontSize: 12))),
                      DataCell(Text(user.userId.toString(),
                          style: const TextStyle(fontSize: 12))),
                      DataCell(Text(user.name,
                          style: const TextStyle(fontSize: 12))),
                      DataCell(Text(user.role.toString(),
                          style: const TextStyle(fontSize: 12))),
                      DataCell(Text(user.phoneNumber,
                          style: const TextStyle(fontSize: 12))),
                      DataCell(Text(user.vehicleNumber,
                          style: const TextStyle(fontSize: 12))),
                      DataCell(Text(user.address.toString(),
                          style: const TextStyle(fontSize: 12))),
                      DataCell(Text(user.emailId,
                          style: const TextStyle(fontSize: 12))),
                      DataCell(Text(user.joiningDate.toString(),
                          style: const TextStyle(fontSize: 12))),
                      DataCell(Text(
                          user.isDeleted.toString() == '0' ? 'Yes' : 'No',
                          style: const TextStyle(fontSize: 12))),
                    ],
                    actions: [
                      CustomAction<UsersList>(
                        icon: Icons.edit,
                        onPressed: (context, user) {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                alignment: Alignment.center,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      16), // Rounded corners
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(
                                      16), // Padding around content
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white, // Background color
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: UserForm(user: user),
                                ),
                              );
                            },
                          );
                        },
                        /*onPressed: (context, user) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return UserForm(
                              user:
                                  user, // Pass the appropriate user object here
                            );
                          }));
                        },*/
                      ),
                      CustomAction<UsersList>(
                        icon: Icons.delete,
                        onPressed: (context, user) async {
                          // Handle delete action
                          await ApiService.deleteMethod(
                                  '${ApiUrls.deleteUserUrl}/${user.id}')
                              .then((jsonString) {
                            final addUserResponseModel =
                                addUserResponseModelFromJson(jsonString);

                            Fluttertoast.showToast(
                                msg: addUserResponseModel.message);
                          });
                        },
                      ),
                    ],
                    filterFunction: filterUsers,
                    showAddButton: true,
                    onAddButtonPressed: () => userFormDialog(context),
                  ),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            userFormDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
      breakpoints: [
        const ResponsiveBreakpoint.resize(350, name: MOBILE),
        const ResponsiveBreakpoint.autoScale(600, name: TABLET),
        const ResponsiveBreakpoint.resize(800, name: DESKTOP),
        const ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
      ],
    );
  }

  void userFormDialog(
    BuildContext context,
  ) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners
        ),
        child: Container(
            padding: const EdgeInsets.all(16), // Padding around content
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white, // Background color
            ),
            width: MediaQuery.of(context).size.width * 0.5,
            child: const UserForm()),
      ),
    );
  }

  Future<void> fetchUsersListApi() async {
    setState(() {
      _isLoading = true;
    });
    await ApiService.getMethod(ApiUrls.getUserUrl).then((onValue) {
      if (kDebugMode) {
        print("response onValue :: $onValue");
      }
      var resData = getUsersListResponseModelFromJson(onValue);
      setState(() {
        _isLoading = false;
      });
      if (resData.status.toString() == "200" ||
          resData.status.toString() == "1") {
        usersList = resData.data ?? [];
        foundUsersList = usersList;
      }
    });
  }
}

class UserForm extends StatefulWidget {
  final UsersList? user;

  const UserForm({Key? key, this.user}) : super(key: key);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  late TextEditingController _userIdController;
  late TextEditingController _userNameController;
  late TextEditingController _userRoleController;
  late TextEditingController _userContactController;
  late TextEditingController _vehicleNumberController;
  late TextEditingController _userAddressController;
  late TextEditingController _userEmailController;
  late TextEditingController _joinedDateController;

  GlobalKey<FormState> userFormKey = GlobalKey<FormState>();

  var rolesOptions = ["Admin", "Manager", "Shop Worker", "Driver"];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with user data if available
    _userIdController = TextEditingController(text: widget.user?.userId ?? '');
    _userNameController = TextEditingController(text: widget.user?.name ?? '');
    _userRoleController =
        TextEditingController(text: widget.user?.role.toString() ?? '');
    _userContactController =
        TextEditingController(text: widget.user?.phoneNumber ?? '');
    _vehicleNumberController =
        TextEditingController(text: widget.user?.vehicleNumber ?? '');
    _userAddressController =
        TextEditingController(text: widget.user?.address ?? '');
    _userEmailController =
        TextEditingController(text: widget.user?.emailId ?? '');
    _joinedDateController =
        TextEditingController(text: widget.user?.joiningDate.toString() ?? '');
  }

  /* @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: widget.user != null
            ? const Text("Update User Details")
            : const Text("Add User Details"),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ResponsiveRowColumn(
          rowMainAxisAlignment: MainAxisAlignment.center,
          rowCrossAxisAlignment: CrossAxisAlignment.center,
          columnMainAxisAlignment: MainAxisAlignment.center,
          columnCrossAxisAlignment: CrossAxisAlignment.center,
          layout: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
              ? ResponsiveRowColumnType.COLUMN
              : ResponsiveRowColumnType.COLUMN,
          children: [
            ResponsiveRowColumnItem(
              rowFlex: 1,
              columnFlex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: userFormKey,
                  child: AnimatedContainer(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(16), // Rounded corners
                    ),
                    width: MediaQuery.of(context).size.width * 0.5,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: widget.user != null,
                          child: CustomTextField(
                            label: 'User ID',
                            controller: _userIdController,
                            isRequired: true,
                            isDateField: false,
                            isTimeField: false,
                          ),
                        ),
                        CustomTextField(
                          label: 'Name',
                          controller: _userNameController,
                          isRequired: true,
                          isDateField: false,
                          isTimeField: false,
                        ),
                        CustomDropdown(
                          label: 'Role',
                          controller: _userRoleController,
                          onChange: (role) {
                            _userRoleController.text = role!;
                          },
                          isRequired: true,
                          options: rolesOptions,
                        ),
                        CustomTextField(
                          label: 'Contact',
                          controller: _userContactController,
                          isRequired: true,
                          isDateField: false,
                          isTimeField: false,
                        ),
                        CustomTextField(
                          label: 'Vehicle Number',
                          controller: _vehicleNumberController,
                          isRequired: false,
                          isDateField: false,
                          isTimeField: false,
                        ),
                        CustomTextField(
                          label: 'Address',
                          controller: _userAddressController,
                          isRequired: false,
                          isDateField: false,
                          isTimeField: false,
                        ),
                        CustomTextField(
                          label: 'Email',
                          controller: _userEmailController,
                          isRequired: false,
                          isDateField: false,
                          isTimeField: false,
                        ),
                        CustomTextField(
                          label: 'Joined Date',
                          controller: _joinedDateController,
                          isRequired: false,
                          isDateField: true,
                          isTimeField: false,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Square shape
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical:
                                          16.0), // Equal padding for square look
                                  minimumSize: const Size(50,
                                      50), // Set minimum size to ensure it's square
                                  elevation:
                                      5, // Optional: Add elevation for shadow effect
                                  backgroundColor: Colors.red,
                                  foregroundColor:
                                      Colors.white // Background color
                                  ),
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Square shape
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical:
                                          16.0), // Equal padding for square look
                                  minimumSize: const Size(50,
                                      50), // Set minimum size to ensure it's square
                                  elevation:
                                      5, // Optional: Add elevation for shadow effect
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white),
                              onPressed: () async {
                                if (userFormKey.currentState!.validate()) {
                                  setState(() {
                                    ApiUrls.loaderOnBtn = true;
                                  });
                                  // Handle save

                                  print(
                                      "Widget .user :: ${widget.user} :: ${widget.user == null}");
                                  if (widget.user == null) {
                                    await addUserApi();
                                  } else {
                                    await updateUserApi();
                                  }
                                } else {
                                  // Show toast
                                  Fluttertoast.showToast(
                                      msg: "All Fields are Mandatory");
                                }
                              },
                              child: Text(widget.user == null
                                  ? 'Add User'
                                  : 'Update User'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: widget.user != null
            ? const Text("Update User Details")
            : const Text("Add User Details"),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600, // Max width for larger screens
              minWidth: 300, // Min width for smaller screens
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: userFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.user != null)
                      CustomTextField(
                        label: 'User ID',
                        controller: _userIdController,
                        isRequired: true,
                        isDateField: false,
                        isTimeField: false,
                      ),
                    CustomTextField(
                      label: 'Name',
                      controller: _userNameController,
                      isRequired: true,
                      isDateField: false,
                      isTimeField: false,
                    ),
                    CustomDropdown(
                      label: 'Role',
                      controller: _userRoleController,
                      onChange: (role) {
                        _userRoleController.text = role!;
                      },
                      isRequired: true,
                      options: rolesOptions,
                    ),
                    CustomTextField(
                      label: 'Contact',
                      controller: _userContactController,
                      isRequired: true,
                      isDateField: false,
                      isTimeField: false,
                    ),
                    CustomTextField(
                      label: 'Vehicle Number',
                      controller: _vehicleNumberController,
                      isRequired: false,
                      isDateField: false,
                      isTimeField: false,
                    ),
                    CustomTextField(
                      label: 'Address',
                      controller: _userAddressController,
                      isRequired: false,
                      isDateField: false,
                      isTimeField: false,
                    ),
                    CustomTextField(
                      label: 'Email',
                      controller: _userEmailController,
                      isRequired: false,
                      isDateField: false,
                      isTimeField: false,
                    ),
                    CustomTextField(
                      label: 'Joined Date',
                      controller: _joinedDateController,
                      isRequired: false,
                      isDateField: true,
                      isTimeField: false,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            minimumSize: const Size(50, 50),
                            elevation: 5,
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 5),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            minimumSize: const Size(50, 50),
                            elevation: 5,
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            if (userFormKey.currentState!.validate()) {
                              setState(() {
                                ApiUrls.loaderOnBtn = true;
                              });
                              if (widget.user == null) {
                                await addUserApi();
                              } else {
                                await updateUserApi();
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "All Fields are Mandatory");
                            }
                          },
                          child: Text(
                              widget.user == null ? 'Add User' : 'Update User'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addUserApi() async {
    await ApiService.postMethod(
            addUserRequesModelToJson(AddUserRequesModel(
                name: _userNameController.text,
                emailId: _userEmailController.text,
                phoneNumber: _userContactController.text,
                role: _userRoleController.text,
                address: _userAddressController.text,
                vehicleNumber: _vehicleNumberController.text,
                joiningDate: _joinedDateController.text,
                password: "test@123",
                isDeleted: false)),
            ApiUrls.addUserUrl)
        .then((jsonString) {
      setState(() {
        ApiUrls.loaderOnBtn = false;
      });
      final addUserResponseModel = addUserResponseModelFromJson(jsonString);
      Fluttertoast.showToast(msg: addUserResponseModel.message);
    });
  }

  Future<void> updateUserApi() async {
    await ApiService.putMethod(
            updateUserRequestModelToJson(UpdateUserRequestModel(
                name: _userNameController.text,
                emailId: _userEmailController.text,
                phoneNumber: _userContactController.text,
                role: _userRoleController.text,
                address: _userAddressController.text,
                vehicleNumber: _vehicleNumberController.text,
                joiningDate: _joinedDateController.text)),
            "${ApiUrls.updateUserUrl}/${widget.user!.id}")
        .then((jsonString) {
      setState(() {
        ApiUrls.loaderOnBtn = false;
      });
      final addUserResponseModel = addUserResponseModelFromJson(jsonString);
      Fluttertoast.showToast(msg: addUserResponseModel.message);
    });
  }
}
