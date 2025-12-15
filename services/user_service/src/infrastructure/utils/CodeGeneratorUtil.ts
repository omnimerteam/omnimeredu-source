import { customAlphabet } from "nanoid";

// Bảng ký tự: chữ in hoa + số
const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

export class CodeGeneratorUtil {
  /**
   * Generate fixed-length (8 chars) school code from name
   * - Lấy chữ cái đầu của mỗi từ trong name (uppercase)
   * - Nếu ít hơn 8 ký tự → thêm ký tự random từ A-Z0-9 để đủ 8
   * - Nếu nhiều hơn 8 ký tự → cắt xuống 8
   * - Luôn đảm bảo đầu ra chỉ gồm chữ in hoa và số
   */
  static generateSchoolCode(name: string): string {
    let initials = name
      .split(" ")
      .filter((word) => word.trim().length > 0)
      .map((word) => word[0].toUpperCase())
      .join("");

    const randomGen = customAlphabet(alphabet);

    if (initials.length < 8) {
      const needed = 8 - initials.length;
      initials += randomGen(needed); // Lấy thêm ký tự random để đủ 8
    } else if (initials.length > 8) {
      initials = initials.slice(-8); // Lẫy 8 ký tự cuối nếu dư (theo logic cũ)
    }

    return initials;
  }

  static generateClassCode(name: string): string {
    let initials = name
      .split(" ")
      .filter((word) => word.trim().length > 0)
      .map((word) => word[0].toUpperCase())
      .join("");

    const randomGen = customAlphabet(alphabet);

    if (initials.length < 10) {
      const needed = 10 - initials.length;
      initials += randomGen(needed);
    } else if (initials.length > 10) {
      initials = initials.slice(-10);
    }

    return initials;
  }
}
