import 'package:wassalni/core/enum/permision.dart';
import 'package:wassalni/core/enum/user_role.dart';

//  الكلاس مسؤول عن تحديد الصلاحيات الممنوحة لكل دور
class RolePermissions {
  // ربط كل دور بمجموعة الصلاحيات التي يمتلكها
  static const Map<UserRole, Set<Permission>> permissions = {
    // -------------------------------
    // صلاحيات العميل
    // -------------------------------
    UserRole.customer: {
      Permission.viewProfile,
      Permission.updateProfile,
      Permission.deleteAccount,

      Permission.createOrder,
      Permission.cancelOrder,
      Permission.viewOwnOrders,
    },

    // -------------------------------
    // صلاحيات السائق
    // -------------------------------
    UserRole.delivery: {
      Permission.viewProfile,
      Permission.updateProfile,
      Permission.deleteAccount,

      Permission.viewAvailableOrders,
      Permission.acceptOrder,
      Permission.rejectOrder,
      Permission.startDelivery,
      Permission.completeDelivery,
      Permission.viewAssignedOrders,

      Permission.updateAvailability,
      Permission.updateVehicleInfo,
      Permission.updateLocation,
    },

    // -------------------------------
    // صلاحيات المدير
    // -------------------------------
    UserRole.admin: {
      Permission.viewProfile,
      Permission.updateProfile,

      Permission.manageUsers,
      Permission.manageDrivers,
      Permission.approveDriver,
      Permission.suspendUser,
      Permission.manageOrders,
      Permission.viewAllOrders,
    },
  };
  // التحقق مما إذا كان الدور يمتلك صلاحية معينة

  static bool hasPermission(UserRole role, Permission permission) {
    return permissions[role]?.contains(permission) ?? false;
  }
}
