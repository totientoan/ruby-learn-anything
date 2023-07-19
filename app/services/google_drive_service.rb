# app/services/google_drive_service.rb
require 'google/apis/drive_v3'
require 'googleauth'

CREDENTIALS_PATH = Rails.root.join('app', 'services', 'upload_drive.json')

module GoogleDriveService
  def self.authorize
    credentials = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(CREDENTIALS_PATH),
      scope: Google::Apis::DriveV3::AUTH_DRIVE
    )
    credentials.fetch_access_token!
    drive_service = Google::Apis::DriveV3::DriveService.new
    drive_service.authorization = credentials
    drive_service
  end
end
