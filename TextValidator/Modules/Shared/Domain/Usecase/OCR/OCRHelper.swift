//
//  OCRHelper.swift
//  TextValidator
//
//  Created by Alfian on 22/10/24.
//

enum KTPKeywords {
    static let province = "PROVINSI"
    static let kabupaten = "KABUPATEN"
    static let kota = "KOTA"
    static let nik = "NIK"
    static let name = "Nama"
    static let pobdob = "Tempat/Tgl Lahir"
    static let gender = "Jenis kelamin"
    static let bloodtype = "Gol. Darah"
    static let address = "Alamat"
    static let rtrw = "RT/RW"
    static let keldesa = "Kel/Desa"
    static let kecamatan = "Kecamatan"
    static let religion = "Agama"
    static let maritalstatus = "Status Perkawinan"
    static let jobtype = "Pekerjaan"
    static let nationality = "Kewarganegaraan"
    static let validuntil = "Berlaku Hingga"
}

let keywords = [
    KTPKeywords.province,
    KTPKeywords.kota,
    KTPKeywords.nik,
    KTPKeywords.name,
    KTPKeywords.pobdob,
    KTPKeywords.gender,
    KTPKeywords.bloodtype,
    KTPKeywords.address,
    KTPKeywords.rtrw,
    KTPKeywords.keldesa,
    KTPKeywords.kecamatan,
    KTPKeywords.religion,
    KTPKeywords.maritalstatus,
    KTPKeywords.jobtype,
    KTPKeywords.nationality,
    KTPKeywords.validuntil,
]

enum OCRRegex {
    static let nik = "^[A-Za-z0-9]{16}+$"
    static let dob = "([A-Za-z]+)[\\.,\\s-]?\\s?(\\d{2})[\\.,\\s-](\\d{2})[\\.,\\s-](\\d{4})"
    static let alphabetical = "^[^0-9]+$"
}

enum OCRDateFormat {
    static let ktp = "dd-MM-yyyy"
}

func levenshteinDistance(_ str1: String, _ str2: String) -> Int {
    let len1 = str1.count
    let len2 = str2.count

    // Create a matrix (2D array) for distances
    var dp = [[Int]](repeating: [Int](repeating: 0, count: len2 + 1), count: len1 + 1)

    // Initialize the matrix
    for i in 0 ... len1 {
        dp[i][0] = i
    }
    for j in 0 ... len2 {
        dp[0][j] = j
    }

    // Convert the strings to arrays of characters
    let arr1 = Array(str1)
    let arr2 = Array(str2)

    // Fill the matrix
    for i in 1 ... len1 {
        for j in 1 ... len2 {
            if arr1[i - 1] == arr2[j - 1] {
                dp[i][j] = dp[i - 1][j - 1] // No change needed
            } else {
                dp[i][j] = min(
                    dp[i - 1][j], // Deletion
                    dp[i][j - 1], // Insertion
                    dp[i - 1][j - 1] // Substitution
                ) + 1
            }
        }
    }

    // The last cell in the matrix contains the Levenshtein distance
    return dp[len1][len2]
}
