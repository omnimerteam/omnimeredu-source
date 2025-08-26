export const getFirebaseAuthErrorMessage = (errorCode: string): string => {
  switch (errorCode) {
    case "auth/email-already-exists":
      return "Email đã tồn tại, vui lòng dùng email khác.";
    case "auth/invalid-email":
      return "Email không hợp lệ.";
    case "auth/weak-password":
      return "Mật khẩu quá yếu, vui lòng chọn mật khẩu mạnh hơn.";
    case "auth/user-not-found":
      return "Tài khoản không tồn tại.";
    case "auth/wrong-password":
      return "Mật khẩu không chính xác.";
    default:
      return "Đã có lỗi xảy ra. Vui lòng thử lại.";
  }
};
