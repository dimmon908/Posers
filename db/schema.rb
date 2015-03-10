# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120611213436) do

  create_table "aankoopberichts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "kunstvoorwerp_id"
    t.text     "message"
    t.text     "sentto"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aankoops", :force => true do |t|
    t.integer  "user_id"
    t.integer  "kunstvoorwerp_id"
    t.integer  "prijs"
    t.text     "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abusereports", :force => true do |t|
    t.text     "message"
    t.integer  "user_id"
    t.integer  "reply_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kunstvoorwerp_id"
  end

  create_table "appreciations", :force => true do |t|
    t.integer  "kunstvoorwerp_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "avatars", :force => true do |t|
    t.integer  "user_id"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.integer  "parent_id"
    t.boolean  "selected_avatar",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "closeups", :force => true do |t|
    t.integer  "kunstvoorwerp_id"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "favourites", :force => true do |t|
    t.integer  "kunstvoorwerp_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forumabusereports", :force => true do |t|
    t.text     "message"
    t.integer  "user_id"
    t.integer  "forummessage_id"
    t.integer  "forumtopic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forumcategories", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "forumparentcategory_id"
    t.integer  "user_id"
    t.integer  "messages_count",         :default => 0
    t.integer  "topics_count",           :default => 0
    t.integer  "lastreply_user_id",      :default => 0
    t.text     "moderators"
    t.datetime "lastreply_at"
    t.text     "short"
    t.integer  "maxwarnings"
    t.integer  "warnings"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forummessages", :force => true do |t|
    t.text     "raw"
    t.text     "processed"
    t.boolean  "locked",        :default => false
    t.boolean  "hidden",        :default => false
    t.integer  "user_id"
    t.integer  "forumtopic_id"
    t.integer  "report_count"
    t.boolean  "topicstart",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reportcount",   :default => 0
  end

  create_table "forumparentcategories", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "category_count"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forumpermissions", :force => true do |t|
    t.string   "title"
    t.string   "action"
    t.string   "mode"
    t.integer  "parent_id"
    t.integer  "role_id"
    t.boolean  "can",        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forumreports", :force => true do |t|
    t.string   "title"
    t.text     "message"
    t.integer  "user_id"
    t.integer  "forummessage_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forumtopics", :force => true do |t|
    t.text     "title"
    t.string   "ttype"
    t.boolean  "locked"
    t.integer  "forumcategory_id"
    t.integer  "user_id"
    t.integer  "message_count",           :default => 0
    t.integer  "lastreply_user_id",       :default => 0
    t.datetime "lastreply_user_datetime"
    t.integer  "message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interieurs", :force => true do |t|
    t.integer  "user_id"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "intmails", :force => true do |t|
    t.string   "inttitle"
    t.string   "title"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "vars"
  end

  create_table "kprops", :force => true do |t|
    t.integer  "kunstproperty_id"
    t.integer  "kunstvoorwerp_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kunstimages", :force => true do |t|
    t.integer  "kunstvoorwerp_id"
    t.string   "content_type"
    t.string   "filename"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "extension"
    t.integer  "width",              :default => 0
    t.integer  "height",             :default => 0
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "kunstproperties", :force => true do |t|
    t.string   "title"
    t.integer  "propertycontainer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kunstvoorwerps", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.text     "sfield"
    t.text     "tags"
    t.integer  "width"
    t.integer  "height"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stijl_id"
    t.integer  "materiaal_id"
    t.integer  "techniek_id"
    t.integer  "kleur_id"
    t.integer  "type_id"
    t.integer  "prijs"
    t.boolean  "active",          :default => false
    t.integer  "kunstimage_id"
    t.integer  "favcount",        :default => 0
    t.integer  "appcount",        :default => 0
    t.boolean  "verkocht",        :default => false
    t.boolean  "houmeopdehoogte", :default => false
    t.integer  "status",          :default => 0
    t.integer  "closeup_id"
    t.integer  "views",           :default => 0
    t.integer  "reacties",        :default => 0
    t.integer  "verzendmethode",  :default => 0
    t.integer  "depth",           :default => 0
    t.string   "material"
    t.boolean  "for_rent"
  end

  create_table "login_sessions", :force => true do |t|
    t.integer  "user_id"
    t.string   "authentication_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "massmails", :force => true do |t|
    t.text     "title"
    t.text     "message"
    t.integer  "user_id"
    t.boolean  "sent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions_roles", :id => false, :force => true do |t|
    t.integer "permission_id"
    t.integer "role_id"
  end

  create_table "prefabmails", :force => true do |t|
    t.text     "content"
    t.integer  "totype"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  create_table "propertycontainers", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "type_id"
  end

  create_table "rents", :force => true do |t|
    t.integer  "user_id"
    t.integer  "kunstvoorwerp_id"
    t.integer  "prijs"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rents", ["kunstvoorwerp_id"], :name => "index_rents_on_kunstvoorwerp_id"
  add_index "rents", ["user_id"], :name => "index_rents_on_user_id"

  create_table "replies", :force => true do |t|
    t.integer  "kunstvoorwerp_id"
    t.integer  "user_id"
    t.text     "raw"
    t.text     "processed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

  create_table "types", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.integer  "dimensie"
  end

  create_table "users", :force => true do |t|
    t.string   "nickname"
    t.string   "email"
    t.string   "original_email"
    t.string   "password"
    t.integer  "userrole_id"
    t.string   "ip"
    t.boolean  "activated"
    t.string   "unid"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "voornaam"
    t.string   "achternaam"
    t.string   "intname"
    t.string   "profile_geboorteplaats"
    t.string   "profile_geboortedatum"
    t.text     "profile_cv"
    t.text     "profile_opleidingen"
    t.text     "profile_exposities"
    t.text     "profile_prijzen"
    t.string   "prive_adres"
    t.string   "prive_woonplaats"
    t.string   "prive_postcode"
    t.string   "prive_land"
    t.text     "profile_description"
    t.text     "profile_disciplines"
    t.text     "prive_bankrek"
    t.text     "profile_website"
    t.boolean  "receive_maillist",       :default => true
    t.string   "prive_telefoonnummer"
    t.string   "utitle",                 :default => "[nickname]"
    t.text     "tussenvoegsel"
    t.text     "achternaam_kort"
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  create_table "webimages", :force => true do |t|
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.string   "thumbnail"
    t.integer  "width"
    t.integer  "height"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "image_file_size"
    t.datetime "image_updated_at"
  end

end
