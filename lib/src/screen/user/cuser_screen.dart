import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:onepali/src/src.dart';

class CUserScreen extends StatefulWidget {
  final ChildUserModel child;
  const CUserScreen({super.key, required this.child});

  @override
  State<CUserScreen> createState() => _CUserScreenState();
}

class _CUserScreenState extends State<CUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  DateTime selectedDate = DateTime.now();
  double? selectedRange;
  String? selectedAvatar;
  bool hasScreenTimeEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.child.fullName);
    selectedRange = widget.child.screenTime;
    selectedDate = DateTime.parse(widget.child.dob);
    selectedAvatar = widget.child.avatarUrl;
    hasScreenTimeEnabled = widget.child.hasScreenTime;
  }

  onYearSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Profile', centerTitle: false),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: InkWell(
                  onTap: () => _showAvatarPicker(context),
                  child: CustomImage(
                    selectedAvatar ?? "",
                    circular: true,
                    height: 150,
                    width: 150,
                    boxFit: BoxFit.cover,
                    isProfileImage: true,
                    imageType:
                        selectedAvatar != null &&
                                selectedAvatar!.startsWith('http')
                            ? CustomImageType.network
                            : CustomImageType.local,
                  ),
                ),
              ),
              Gaps.verticalGapOf(20),
              TitleActionChild(
                titlePadding: EdgeInsets.only(bottom: 8),
                title: 'Name',
                child: CustomTextField(
                  hintText: 'Enter your Full Name',
                  keyboardType: TextInputType.name,
                  controller: _nameController,
                  prefixIcon: Icon(Icons.person_outline_rounded),
                  validation: (value) => Validator.empty(value ?? ""),
                ),
              ),
              Gaps.verticalGapOf(20),
              TitleActionChild(
                title: 'Birthday',
                titlePadding: EdgeInsets.only(bottom: 8),
                child: CupertinoDatePickerField(
                  initialDate: selectedDate,
                  onDateChanged: onYearSelected,
                  maxYear: DateTime.now().year,
                  showMonth: true,
                  showDay: false,
                ),
              ),
              Gaps.verticalGapOf(20),
              // Screen Time Toggle
              ListTile(
                title: Text('Screen Time', style: AppStyles.text16PxMedium),

                dense: true,
                contentPadding: EdgeInsets.zero,
                trailing: CupertinoSwitch(
                  value: hasScreenTimeEnabled,
                  onChanged: (value) {
                    setState(() {
                      hasScreenTimeEnabled = value;
                      if (!value) {
                        selectedRange = 0;
                      } else if (selectedRange == 0) {
                        selectedRange = 30;
                      }
                    });
                  },
                  activeTrackColor: AppColors.kButtonGreen,
                ),
              ),
              Gaps.verticalGapOf(10),
              if (hasScreenTimeEnabled) ...[
                TitleActionChild(
                  title: 'Screen Time',
                  titlePadding: EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.kButtonGrey.withValues(alpha: 0.5),
                      ),
                    ),
                    child: CustomRangeSlider(
                      min: 5,
                      max: 120,
                      value: selectedRange ?? 30,
                      onChanged: (val) {
                        setState(() {
                          selectedRange = val;
                        });
                      },
                      recommended: selectedRange ?? 30,
                    ),
                  ),
                ),
                Gaps.verticalGapOf(20),
                Center(
                  child: Text(
                    'We will notify in the app when the time is up.',
                    style: AppStyles.text14PxRegular,
                    textAlign: TextAlign.center,
                  ),
                ),
              ] ,
              Gaps.verticalGapOf(40),
              CustomMaterialButton(
                onTap: () async {
                  _showDeleteConfirmationDialog();
                },
                isLoading:
                    context.watch<ChildUserProvider>().status ==
                    DataFetchStatus.loading,
                label: 'Delete Profile',
                textStyle: AppStyles.text16PxRegular.copyWith(
                  color: AppColors.kRed,
                ),
                showBorder: false,
                elevation: 0,
                fillButton: false,
              ),
              Gaps.verticalGapOf(20),
              CustomMaterialButton(
                onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    String avatarUrl = await _handleAvatarUploadIfNeeded(
                      selectedAvatar ?? AppConstants.avatarList[0],
                    );
                    if (!context.mounted) return;
                    await context
                        .read<ChildUserProvider>()
                        .updateChildUserProfile(
                          childUid: widget.child.uid,
                          fullName: _nameController.text.trim(),
                          dob: selectedDate.toString(),
                          screenTime:
                              hasScreenTimeEnabled ? (selectedRange ?? 0) : 0,
                          avatarUrl: avatarUrl,
                          hasScreenTime: hasScreenTimeEnabled,
                        );
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                isLoading:
                    context.watch<ChildUserProvider>().status ==
                    DataFetchStatus.loading,
                label: 'Update',
                elevation: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAvatarPicker(BuildContext context) async {
    if (!context.mounted) return;
    await showModalBottomSheet(
      context: context,
      routeSettings: const RouteSettings(name: AppConstants.avatarPickerModal),
      builder: (_) {
        return SizedBox(
          height: 200,
          child: GridView.count(
            crossAxisCount: 5,
            children: List.generate(AppConstants.avatarList.length, (idx) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAvatar = AppConstants.avatarList[idx];
                  });
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(AppConstants.avatarList[idx]),
                    radius: 30,
                    child:
                        selectedAvatar == AppConstants.avatarList[idx]
                            ? Icon(Icons.check, color: Colors.white)
                            : null,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Future<String> _handleAvatarUploadIfNeeded(String avatar) async {
    // If avatar is already a URL, return as is
    if (avatar.startsWith('http')) return avatar;
    // Otherwise, upload and get URL
    final childUid = widget.child.uid;
    return await MediaUtility.uploadAvatarImage(avatar, childUid);
  }

  void _showDeleteConfirmationDialog() async {
    DialogManager.showCustomDialog(
      context: context,
      title: 'Delete profile',
      content:
          'Are you sure you want to delete ${widget.child.fullName}\'s profile? This action cannot be undone and will remove all associated data.',
      confirmButtonText: 'Delete',
      onConfirm: () async {
        final navigator = Navigator.of(context);
        final childUserProvider = Provider.of<ChildUserProvider>(
          context,
          listen: false,
        );

        navigator.pop();

        if (mounted) {
          try {
            await childUserProvider.deleteChildUser(widget.child.uid);
            if (mounted &&
                childUserProvider.status == DataFetchStatus.success) {
              navigator.pop();
            }
          } catch (e) {
            // we don't navigate back on error
          }
        }
      },
    );
  }
}
