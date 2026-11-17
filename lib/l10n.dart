import 'package:flutter/foundation.dart';

import 'settings.dart';

/// The app's wording in Thai, keyed by the English it replaces.
///
/// English is written straight into the code, so the code stays easy to read; `'Text'.tr` looks it
/// up here when the app is in Thai. Templates use {name} placeholders, filled in by [Tr.trf].
/// Anything missing simply stays in English.
const _th = <String, String>{
  // Tabs, titles and common words
  'Focus': 'โฟกัส',
  'Notes': 'โน้ต',
  'Class': 'คลาส',
  'Settings': 'ตั้งค่า',
  'Focus session': 'กำลังโฟกัส',
  'Lecture notes': 'โน้ตการเรียน',
  'Class timer': 'จับเวลาคลาส',
  'Timetable': 'ตารางเรียน',
  'Trash': 'ถังขยะ',
  'Cancel': 'ยกเลิก',
  'Save': 'บันทึก',
  'Delete': 'ลบ',
  'Edit': 'แก้ไข',
  'Restore': 'กู้คืน',
  'Create': 'สร้าง',
  'Rename': 'เปลี่ยนชื่อ',
  'Done': 'เสร็จ',
  'Clear': 'ล้าง',
  'More': 'เพิ่มเติม',
  'OK': 'ตกลง',
  'Undo': 'เลิกทำ',
  'Start': 'เริ่ม',
  'Send': 'ส่ง',
  'Pause': 'พัก',
  'Play': 'เล่น',
  'Code': 'รหัส',
  'Confirm': 'ยืนยัน',
  'Empty': 'ว่าง',
  'Download': 'ดาวน์โหลด',
  'Today': 'วันนี้',

  // Welcome and roles
  'Welcome to Sati': 'ยินดีต้อนรับสู่ Sati',
  'Fewer distractions in class, better notes after it. How will you use it?':
      'ไม่วอกแวกในคลาส ได้โน้ตดีๆ หลังเรียน คุณจะใช้แอปนี้แบบไหน?',
  'You can change this any time in Settings.': 'เปลี่ยนได้ทุกเมื่อในการตั้งค่า',
  'Choose one to continue': 'เลือกหนึ่งอย่างเพื่อไปต่อ',
  'Continue as {role}': 'ไปต่อในฐานะ{role}',
  'Student': 'นักศึกษา',
  'Lecturer': 'อาจารย์',
  'Lock distracting apps during class and keep your lecture notes.':
      'ล็อกแอปที่ทำให้วอกแวกระหว่างเรียน และเก็บโน้ตการเรียนไว้',
  'Everything students get, plus a class timer that runs your lesson plan.':
      'ได้ทุกอย่างแบบนักศึกษา พร้อมตัวจับเวลาคลาสตามแผนการสอนของคุณ',

  // Focus: setup
  'Ready': 'พร้อม',
  'Setup needed': 'ต้องตั้งค่า',
  'Close the apps that pull you away, on a rhythm that suits you.':
      'ปิดแอปที่ดึงความสนใจ ตามจังหวะที่เหมาะกับคุณ',
  'One-time setup': 'ตั้งค่าครั้งเดียว',
  'Sati needs Accessibility access to see which app is open. In Settings, open "Installed apps" (or "Downloaded apps"), tap Sati and turn it on.':
      'Sati ต้องใช้สิทธิ์การช่วยเหลือพิเศษเพื่อดูว่ากำลังเปิดแอปไหนอยู่ ในการตั้งค่า ให้เปิด "แอปที่ติดตั้ง" (หรือ "แอปที่ดาวน์โหลด") แตะ Sati แล้วเปิดใช้',
  'Open Accessibility settings': 'เปิดการตั้งค่าการช่วยเหลือพิเศษ',
  'Lock apps by themselves when each class starts': 'ล็อกแอปให้เองเมื่อแต่ละคลาสเริ่ม',
  'Next: {course}, {day} {time}': 'ถัดไป: {course} {day} {time}',
  'Apps': 'แอป',
  'Apps to lock': 'แอปที่จะล็อก',
  'None chosen yet': 'ยังไม่ได้เลือก',
  '1 app': '1 แอป',
  '{n} apps': '{n} แอป',
  '+{n} more': 'อีก {n}',
  'Strict mode': 'โหมดเข้มงวด',
  "Also blocks Settings and uninstalling while locked, so the lock can't be switched off. Your code still ends it.":
      'บล็อกการตั้งค่าและการถอนแอปด้วยระหว่างล็อก จึงปิดการล็อกไม่ได้ แต่ยังใช้รหัสปลดได้',
  'Rhythm': 'จังหวะ',
  'Each cycle': 'แต่ละรอบ',
  '{time} · repeats': '{time} · วนซ้ำ',
  '{time} · once': '{time} · ครั้งเดียว',
  'Lock for': 'ล็อกนาน',
  'Free for': 'ว่างนาน',
  'Start with': 'เริ่มด้วย',
  'Locked': 'ล็อก',
  'Free': 'ว่าง',
  'Repeat': 'วนซ้ำ',
  'Keep switching between locked and free until you end it with your code':
      'สลับระหว่างล็อกกับว่างไปเรื่อยๆ จนกว่าจะใช้รหัสปลด',
  'Stop after one locked and one free period': 'หยุดหลังล็อกหนึ่งช่วงและว่างหนึ่งช่วง',
  'Lecture': 'การบรรยาย',
  'Record lecture': 'อัดเสียงการบรรยาย',
  'Records the lecture until the session ends. Afterwards, turn it into text and notes in Notes, all on this phone.':
      'อัดเสียงการบรรยายจนจบเซสชัน แล้วแปลงเป็นข้อความและโน้ตได้ในแท็บโน้ต ทั้งหมดบนมือถือเครื่องนี้',
  'For a clear recording': 'เพื่อให้อัดเสียงได้ชัด',
  'Sit near the front, as close to the lecturer as you can.': 'นั่งด้านหน้า ใกล้ผู้สอนให้มากที่สุด',
  'Put the phone face up on the desk, not in a bag or pocket.': 'วางมือถือหงายบนโต๊ะ ไม่ใส่กระเป๋าหรือกระเป๋ากางเกง',
  'For the clearest sound, a clip-on wireless mic on the lecturer.': 'ถ้าอยากได้เสียงชัดที่สุด ใช้ไมค์ไร้สายแบบหนีบติดผู้สอน',
  'Tap Mark important in the notification at key moments.': 'แตะ "ทำเครื่องหมายว่าสำคัญ" ในการแจ้งเตือนตอนช่วงสำคัญ',
  'Cancel code': 'รหัสยกเลิก',
  'If you set the timer too long, enter this code to end the lock early.':
      'ถ้าตั้งเวลานานเกินไป ใส่รหัสนี้เพื่อปลดล็อกก่อนเวลา',
  '4–8 digits. Pick one you will remember.': 'ตัวเลข 4–8 หลัก เลือกที่จำได้',
  'Code must be 4–8 digits': 'รหัสต้องเป็นตัวเลข 4–8 หลัก',
  'Codes do not match': 'รหัสไม่ตรงกัน',
  'Turn on Accessibility access first.': 'เปิดสิทธิ์การช่วยเหลือพิเศษก่อน',
  'Choose at least one app.': 'เลือกอย่างน้อยหนึ่งแอป',
  'Start session': 'เริ่มเซสชัน',
  'Recording needs the microphone. Allow it in Settings → Apps → Sati → Permissions, or turn off "Record lecture".':
      'การอัดเสียงต้องใช้ไมโครโฟน อนุญาตได้ที่ การตั้งค่า → แอป → Sati → สิทธิ์ หรือปิด "อัดเสียงการบรรยาย"',

  // Focus: running
  'until the session ends': 'จนจบเซสชัน',
  'until your apps open': 'จนกว่าแอปจะเปิด',
  'until your apps lock': 'จนกว่าแอปจะล็อก',
  'LOCKED': 'ล็อกอยู่',
  'FREE TIME': 'เวลาว่าง',
  'Free time': 'เวลาว่าง',
  'Locked {time}': 'ล็อก {time}',
  'Free {time}': 'ว่าง {time}',
  'Repeats': 'วนซ้ำ',
  'Strict': 'เข้มงวด',
  'Recording lecture': 'กำลังอัดเสียง',
  'Recording': 'กำลังอัดเสียง',
  '{time} so far': 'ผ่านไป {time}',
  'Mark this moment': 'มาร์กตรงนี้',
  'Locked apps': 'แอปที่ล็อก',
  'No apps chosen': 'ยังไม่ได้เลือกแอป',
  'End early with code': 'ปลดก่อนเวลาด้วยรหัส',
  'Enter your code': 'ใส่รหัส',
  'The code you chose when you started this session.': 'รหัสที่คุณตั้งตอนเริ่มเซสชันนี้',
  'End lock': 'ปลดล็อก',
  'Lock ended': 'ปลดล็อกแล้ว',
  'Wrong code': 'รหัสไม่ถูกต้อง',
  "Marked. You'll find it starred in Notes.": 'มาร์กแล้ว จะเห็นเป็นดาวในแท็บโน้ต',
  'Nothing is recording right now.': 'ตอนนี้ไม่ได้อัดเสียงอยู่',

  // Focus stats
  'Your focus week shows up here after your first session.': 'สรุปการโฟกัสรายสัปดาห์จะขึ้นที่นี่หลังเซสชันแรก',
  'THIS WEEK': 'สัปดาห์นี้',
  'focused': 'ที่โฟกัส',
  '{n}-day streak': 'ต่อเนื่อง {n} วัน',
  'Your focus': 'การโฟกัสของคุณ',
  'This week': 'สัปดาห์นี้',
  'Best day': 'วันที่ดีที่สุด',
  'Streak': 'ต่อเนื่อง',
  '1 day': '1 วัน',
  '{n} days': '{n} วัน',
  'Focus time, last 7 days': 'เวลาโฟกัส 7 วันล่าสุด',
  '{n} sessions. Press and hold a bar for its time.': '{n} เซสชัน กดค้างที่แท่งเพื่อดูเวลา',
  '1 session. Press and hold a bar for its time.': '1 เซสชัน กดค้างที่แท่งเพื่อดูเวลา',
  'Show as table': 'แสดงเป็นตาราง',
  'Most tried while locked': 'แอปที่พยายามเปิดบ่อยที่สุดตอนล็อก',
  'No locked apps opened this week. Nice.': 'สัปดาห์นี้ไม่ได้เปิดแอปที่ล็อกเลย เยี่ยมมาก',
  '1 try': '1 ครั้ง',
  '{n} tries': '{n} ครั้ง',
  'Each try is one time you opened a locked app. Fewer tries means the habit is fading.':
      'นับหนึ่งครั้งทุกครั้งที่เปิดแอปที่ล็อกอยู่ ยิ่งน้อยแปลว่านิสัยเดิมกำลังหายไป',

  // App picker
  'Choose apps': 'เลือกแอป',
  'Done · {apps}': 'เสร็จ · {apps}',
  'Could not load apps': 'โหลดรายการแอปไม่ได้',
  'Search apps': 'ค้นหาแอป',
  'No apps match': 'ไม่พบแอป',
  'Nothing installed is called "{query}".': 'ไม่มีแอปชื่อ "{query}"',

  // Timetable
  'Add class': 'เพิ่มคลาส',
  'Lock apps in class': 'ล็อกแอปตอนเรียน',
  'Choose apps on the Focus tab first.': 'เลือกแอปที่แท็บโฟกัสก่อน',
  'Locks the {apps} chosen on the Focus tab, for up to 3 hours of each class.':
      'ล็อก{apps}ที่เลือกในแท็บโฟกัส นานสูงสุด 3 ชั่วโมงต่อคลาส',
  'app': 'แอป',
  'Next: {course} · {day} {time}': 'ถัดไป: {course} · {day} {time}',
  'Locks may start a few minutes late': 'การล็อกอาจเริ่มช้าไปไม่กี่นาที',
  'Allow Sati to set exact alarms so the lock starts right on time.': 'อนุญาตให้ Sati ตั้งนาฬิกาปลุกแบบตรงเวลา เพื่อให้ล็อกเริ่มตรงเวลา',
  'Allow exact alarms': 'อนุญาตนาฬิกาปลุกแบบตรงเวลา',
  'Change code': 'เปลี่ยนรหัส',
  'Class code': 'รหัสคลาส',
  'A code is set. Enter a new one here to change it.': 'ตั้งรหัสไว้แล้ว ใส่รหัสใหม่ที่นี่เพื่อเปลี่ยน',
  'Like the Focus code: enter it on the lock screen to end a class lock early.':
      'เหมือนรหัสโฟกัส: ใส่ที่หน้าจอล็อกเพื่อปลดล็อกคลาสก่อนเวลา',
  'Save new code': 'บันทึกรหัสใหม่',
  'Add your classes': 'เพิ่มคลาสของคุณ',
  "Enter each weekly class once. Sati locks your apps when it starts and offers to record the lecture into that course's folder.":
      'ใส่แต่ละคลาสในสัปดาห์ครั้งเดียว Sati จะล็อกแอปเมื่อคลาสเริ่ม และเสนอให้อัดเสียงเก็บในโฟลเดอร์ของวิชานั้น',
  'Offers to record': 'เสนอให้อัดเสียง',
  'A class that starts while another lock is running leaves that lock as it is.': 'ถ้าคลาสเริ่มตอนที่ล็อกอื่นยังทำงานอยู่ จะไม่เปลี่ยนล็อกนั้น',
  'Edit class': 'แก้ไขคลาส',
  'For example, Physics 101': 'เช่น ฟิสิกส์ 101',
  'Starts': 'เริ่ม',
  'Ends': 'จบ',
  'Offer to record': 'เสนอให้อัดเสียง',
  'A notification lets you start recording with one tap': 'การแจ้งเตือนจะให้เริ่มอัดเสียงได้ในแตะเดียว',
  'Save class': 'บันทึกคลาส',
  'Set a 4–8 digit code to end a class lock early.': 'ตั้งรหัส 4–8 หลักไว้ปลดล็อกคลาสก่อนเวลา',
  "The codes don't match.": 'รหัสไม่ตรงกัน',
  'Choose the apps to lock on the Focus tab first.': 'เลือกแอปที่จะล็อกในแท็บโฟกัสก่อน',
  'Give the class a name.': 'ตั้งชื่อคลาส',
  'The class has to end after it starts.': 'เวลาจบต้องหลังเวลาเริ่ม',
  'Classes can be up to 4 hours.': 'คลาสยาวได้สูงสุด 4 ชั่วโมง',
  'It overlaps {course} ({start}–{end}).': 'เวลาชนกับ {course} ({start}–{end})',
  'Monday': 'วันจันทร์',
  'Tuesday': 'วันอังคาร',
  'Wednesday': 'วันพุธ',
  'Thursday': 'วันพฤหัสบดี',
  'Friday': 'วันศุกร์',
  'Saturday': 'วันเสาร์',
  'Sunday': 'วันอาทิตย์',
  'Mon': 'จ.',
  'Tue': 'อ.',
  'Wed': 'พ.',
  'Thu': 'พฤ.',
  'Fri': 'ศ.',
  'Sat': 'ส.',
  'Sun': 'อา.',

  // Notes
  'Ask your notes': 'ถามโน้ตของคุณ',
  '"What will be on the exam?" Type or say it.': '"สอบจะออกอะไร?" พิมพ์หรือพูดก็ได้',
  'Folders': 'โฟลเดอร์',
  'New folder': 'โฟลเดอร์ใหม่',
  'For a course or topic': 'สำหรับวิชาหรือหัวข้อ',
  'Unsorted': 'ยังไม่จัด',
  'No lectures yet': 'ยังไม่มีการบรรยาย',
  'Turn on "Record lecture" when you start a lock session, and the transcript lands here.':
      'เปิด "อัดเสียงการบรรยาย" ตอนเริ่มเซสชันล็อก แล้วบันทึกจะมาอยู่ที่นี่',
  'Everything is sorted into folders.': 'ทุกอย่างจัดเข้าโฟลเดอร์แล้ว',
  'Swipe a recording left to move it to the trash, or use its three-dot menu to move it to a folder.':
      'ปัดไปทางซ้ายเพื่อทิ้งลงถังขยะ หรือใช้เมนูสามจุดเพื่อย้ายเข้าโฟลเดอร์',
  '1 recording': '1 รายการ',
  '{n} recordings': '{n} รายการ',
  '{count} · deleted for good after {days} days': '{count} · ลบถาวรหลัง {days} วัน',
  'Could not load lectures': 'โหลดการบรรยายไม่ได้',
  'Rename folder': 'เปลี่ยนชื่อโฟลเดอร์',
  'Folder name': 'ชื่อโฟลเดอร์',
  'Move to': 'ย้ายไปที่',
  'New folder…': 'โฟลเดอร์ใหม่…',
  'Moved to Unsorted': 'ย้ายไปยังไม่จัดแล้ว',
  'Moved to {folder}': 'ย้ายไป {folder} แล้ว',
  'Moved to trash': 'ทิ้งลงถังขยะแล้ว',
  'Delete forever?': 'ลบถาวร?',
  'The transcript and summary will be removed from this phone. This can’t be undone.':
      'บันทึกและสรุปจะถูกลบจากมือถือเครื่องนี้ และกู้คืนไม่ได้',
  'Restored': 'กู้คืนแล้ว',
  'Recording now': 'กำลังอัดเสียง',
  '{n} words': '{n} คำ',
  '{time} recording': 'เสียงยาว {time}',
  'Nothing recorded yet': 'ยังไม่มีเสียง',
  'Not transcribed yet': 'ยังไม่ได้ถอดเสียง',
  'Summarized': 'สรุปแล้ว',
  'Not summarized': 'ยังไม่สรุป',
  '1 mark': '1 มาร์ก',
  '{n} marks': '{n} มาร์ก',
  'Deleted in {n} days': 'จะลบใน {n} วัน',
  'Delete forever': 'ลบถาวร',
  'Move to folder': 'ย้ายเข้าโฟลเดอร์',
  'Move to trash': 'ทิ้งลงถังขยะ',
  'Delete "{folder}"?': 'ลบ "{folder}"?',
  'The folder is empty.': 'โฟลเดอร์ว่างอยู่',
  'The {count} in it will go back to Unsorted. No recordings are deleted.':
      '{count}ข้างในจะกลับไปที่ยังไม่จัด ไม่มีเสียงถูกลบ',
  'Delete folder': 'ลบโฟลเดอร์',
  'Folder options': 'ตัวเลือกโฟลเดอร์',
  'Nothing here yet': 'ยังไม่มีอะไร',
  'No recordings in this folder yet. Open Lecture notes and use the three-dot menu on a recording to move it here.':
      'โฟลเดอร์นี้ยังว่าง เปิดโน้ตการเรียนแล้วใช้เมนูสามจุดของรายการเพื่อย้ายมาที่นี่',
  'Empty the trash?': 'ล้างถังขยะ?',
  'The {count} in the trash will be removed from this phone. This can’t be undone.':
      '{count}ในถังขยะจะถูกลบจากมือถือเครื่องนี้ และกู้คืนไม่ได้',
  'Empty trash': 'ล้างถังขยะ',
  'All clear': 'ว่างเปล่า',
  'The trash is empty.': 'ถังขยะว่าง',
  'Recordings here are deleted for good after {days} days. Use the three-dot menu to restore one.':
      'รายการในนี้จะถูกลบถาวรหลัง {days} วัน ใช้เมนูสามจุดเพื่อกู้คืน',
  'Enter a name': 'ใส่ชื่อ',
  'Use {n} characters or fewer': 'ใช้ไม่เกิน {n} ตัวอักษร',
  'There is already a folder called "{name}"': 'มีโฟลเดอร์ชื่อ "{name}" อยู่แล้ว',

  // Lecture page
  'Download the {what}?': 'ดาวน์โหลด{what}?',
  "It's {mb} MB, downloaded once over Wi-Fi. After that it works offline and nothing leaves your phone.":
      'ขนาด {mb} MB ดาวน์โหลดครั้งเดียวผ่าน Wi-Fi หลังจากนั้นใช้งานออฟไลน์ได้ และไม่มีข้อมูลออกจากมือถือ',
  'speech model': 'โมเดลถอดเสียง',
  'notes AI': 'AI ทำโน้ต',
  'Downloading the {what}…': 'กำลังดาวน์โหลด{what}…',
  'Transcribing on this phone…': 'กำลังถอดเสียงบนมือถือ…',
  'Starting the notes AI…': 'กำลังเริ่ม AI ทำโน้ต…',
  'Writing flashcards…': 'กำลังเขียนแฟลชการ์ด…',
  'Reading part {n} of {total}…': 'กำลังอ่านส่วนที่ {n} จาก {total}…',
  'Putting the notes together…': 'กำลังรวมโน้ต…',
  'Still recording. Come back when the session ends.': 'ยังอัดเสียงอยู่ กลับมาอีกครั้งเมื่อจบเซสชัน',
  'Working…': 'กำลังทำงาน…',
  'Keep the app open. The screen stays on until it finishes.': 'เปิดแอปค้างไว้ หน้าจอจะติดอยู่จนเสร็จ',
  'Pausing…': 'กำลังพัก…',
  'Turn this recording into text': 'แปลงเสียงนี้เป็นข้อความ',
  'Whisper runs on this phone, so the recording never leaves it. An hour of lecture can take a while; you can pause and carry on later.':
      'Whisper ทำงานบนมือถือ เสียงจึงไม่ออกจากเครื่อง การบรรยายหนึ่งชั่วโมงอาจใช้เวลาสักพัก พักแล้วทำต่อทีหลังได้',
  'Transcribe on this phone': 'ถอดเสียงบนมือถือ',
  'Carry on transcribing ({n}% done)': 'ถอดเสียงต่อ (เสร็จแล้ว {n}%)',
  'Summary': 'สรุป',
  'Summarize on this phone': 'สรุปบนมือถือ',
  'Summarize again': 'สรุปอีกครั้ง',
  'Make flashcards': 'ทำแฟลชการ์ด',
  'Study {n} flashcards': 'ทบทวนแฟลชการ์ด {n} ใบ',
  'Questions and answers from this lecture, for revision': 'คำถามและคำตอบจากการบรรยายนี้ สำหรับทบทวน',
  'Tap a card to see the answer': 'แตะการ์ดเพื่อดูคำตอบ',
  'Make new cards': 'ทำการ์ดใหม่',
  'Nothing recorded': 'ไม่มีเสียง',
  'Nothing was recorded during this session.': 'ไม่มีการอัดเสียงในเซสชันนี้',
  'Transcript': 'บันทึกคำพูด',
  "This recording can't be played.": 'เล่นเสียงนี้ไม่ได้',
  'Marked important': 'มาร์กว่าสำคัญ',
  'Tap to listen from just before this moment': 'แตะเพื่อฟังตั้งแต่ก่อนช่วงนี้เล็กน้อย',
  'In the trash · deleted for good in {n} days': 'อยู่ในถังขยะ · จะลบถาวรใน {n} วัน',

  // Flashcards
  'Flashcards · {title}': 'แฟลชการ์ด · {title}',
  'You knew {known} of {total}': 'คุณรู้ {known} จาก {total}',
  'Every card. Nice work.': 'ครบทุกใบ เก่งมาก',
  'Go over the ones you missed once more.': 'ทบทวนใบที่พลาดอีกรอบ',
  'Study missed': 'ทบทวนใบที่พลาด',
  'Start over': 'เริ่มใหม่',
  'Card {n} of {total}': 'ใบที่ {n} จาก {total}',
  '{n} known': 'รู้แล้ว {n}',
  'ANSWER': 'คำตอบ',
  'QUESTION': 'คำถาม',
  'Tap to see the answer': 'แตะเพื่อดูคำตอบ',
  'Again': 'อีกครั้ง',
  'Knew it': 'รู้แล้ว',
  'Show answer': 'ดูคำตอบ',

  // Ask your notes
  'What will be on the exam?': 'สอบจะออกอะไร?',
  'What homework was set?': 'มีการบ้านอะไรบ้าง?',
  'What were the key terms?': 'คำศัพท์สำคัญมีอะไรบ้าง?',
  'All lectures': 'ทุกการบรรยาย',
  'Ask about your lectures': 'ถามเรื่องการบรรยายของคุณ',
  'Answers come from your transcripts, written by the AI on this phone. Tap the microphone to ask out loud.':
      'คำตอบมาจากบันทึกคำพูดของคุณ เขียนโดย AI บนมือถือ แตะไมโครโฟนเพื่อถามด้วยเสียง',
  'Stop and ask': 'หยุดแล้วถาม',
  'Ask by voice': 'ถามด้วยเสียง',
  'Listening… tap stop when done': 'กำลังฟัง… แตะหยุดเมื่อพูดจบ',
  'Ask a question': 'พิมพ์คำถาม',
  'Listening': 'กำลังฟัง',
  'Looking through your lectures…': 'กำลังค้นในการบรรยายของคุณ…',
  'Read aloud': 'อ่านออกเสียง',
  'Download the notes AI in Settings first.': 'ดาวน์โหลด AI ทำโน้ตในการตั้งค่าก่อน',
  'Transcribe a lecture first, then ask about it here.': 'ถอดเสียงการบรรยายก่อน แล้วค่อยถามที่นี่',
  "I couldn't find that in your lectures.": 'ไม่พบเรื่องนี้ในการบรรยายของคุณ',
  "Didn't catch that. Try again.": 'ฟังไม่ทัน ลองอีกครั้ง',
  'Download a speech model in Settings to ask by voice.': 'ดาวน์โหลดโมเดลถอดเสียงในการตั้งค่า เพื่อถามด้วยเสียง',
  'The microphone is busy, maybe with a lecture recording.': 'ไมโครโฟนไม่ว่าง อาจกำลังอัดเสียงการบรรยายอยู่',

  // Class timer and plans
  'New plan': 'แผนใหม่',
  'Plan your first class': 'วางแผนคลาสแรก',
  'No lesson plans yet. Build your lecture as timed segments, then run the timer during class to see how the time really goes.':
      'ยังไม่มีแผนการสอน แบ่งการบรรยายเป็นช่วงพร้อมเวลา แล้วจับเวลาระหว่างสอนเพื่อดูว่าใช้เวลาจริงเท่าไร',
  'Lesson plans': 'แผนการสอน',
  'Past classes': 'คลาสที่ผ่านมา',
  'CLASS IN PROGRESS': 'คลาสกำลังดำเนินอยู่',
  'Class in progress · {segment}': 'คลาสกำลังดำเนินอยู่ · {segment}',
  '{n} segments · {time}': '{n} ช่วง · {time}',
  'Not now': 'ไม่ใช่ตอนนี้',
  'Make it {time}': 'ปรับเป็น {time}',
  '{title} is now {time}': '{title} ตอนนี้เป็น {time}',
  '{title} ran about {n} min over in your last {classes} classes.': '{title} เกินเวลาราว {n} นาทีใน {classes} คลาสล่าสุด',
  '{title} finished about {n} min early in your last {classes} classes.':
      '{title} เสร็จเร็วราว {n} นาทีใน {classes} คลาสล่าสุด',
  'Give the plan a name.': 'ตั้งชื่อแผน',
  'Add at least one segment.': 'เพิ่มอย่างน้อยหนึ่งช่วง',
  'Every segment needs a title.': 'ทุกช่วงต้องมีชื่อ',
  'Each segment must be 1–{max} minutes.': 'แต่ละช่วงต้องยาว 1–{max} นาที',
  'Delete this plan?': 'ลบแผนนี้?',
  'Reports from classes you already taught will be kept.': 'รายงานของคลาสที่สอนไปแล้วจะยังเก็บไว้',
  'Edit plan': 'แก้ไขแผน',
  'Plan name': 'ชื่อแผน',
  'Running order': 'ลำดับการสอน',
  'Segments': 'ช่วง',
  'Add segment': 'เพิ่มช่วง',
  'Segment': 'ช่วง',
  'Min': 'นาที',
  'Remove segment': 'ลบช่วง',
  'Save · {time}': 'บันทึก · {time}',
  'Finish class?': 'จบคลาส?',
  'This ends the timer and saves the report.': 'จะหยุดจับเวลาและบันทึกรายงาน',
  'Finish': 'จบ',
  'Cancel this class?': 'ยกเลิกคลาสนี้?',
  "The timer stops and this class's timing won't be saved.": 'ตัวจับเวลาจะหยุด และไม่บันทึกเวลาของคลาสนี้',
  'Cancel class': 'ยกเลิกคลาส',
  'Keep going': 'ทำต่อ',
  'Finish class': 'จบคลาส',
  'Next: {segment}': 'ถัดไป: {segment}',
  'Back to {segment}': 'กลับไป {segment}',
  'Last segment of {plan}': 'ช่วงสุดท้ายของ {plan}',
  'Segment {n} of {total}': 'ช่วงที่ {n} จาก {total}',
  'Over by': 'เกินมา',
  'Time left': 'เหลือเวลา',
  'of {time}': 'จาก {time}',
  '{actual} of {planned}': '{actual} จาก {planned}',
  'On schedule': 'ตรงตามแผน',
  '{n} min behind': 'ช้ากว่าแผน {n} นาที',
  '{n} min ahead': 'เร็วกว่าแผน {n} นาที',
  'Finished on time': 'จบตรงเวลา',
  'On time': 'ตรงเวลา',
  'Finished {n} min early': 'จบเร็ว {n} นาที',
  'Ran {n} min over': 'เกินเวลา {n} นาที',
  '{n} min early': 'เร็ว {n} นาที',
  '{n} min over': 'เกิน {n} นาที',
  'Delete this report?': 'ลบรายงานนี้?',
  "This class's timing will be removed from this phone.": 'เวลาของคลาสนี้จะถูกลบจากมือถือเครื่องนี้',
  'Took': 'ใช้เวลา',
  'Planned': 'ตามแผน',
  'Early by': 'เร็วกว่า',
  'Planned vs. actual': 'แผนเทียบกับจริง',
  'Actual': 'จริง',
  'Across weeks': 'เทียบหลายสัปดาห์',
  "Bars are drawn relative to each segment's planned time, so anything above the line ran over. Press and hold a bar for its time.":
      'ความสูงแท่งเทียบกับเวลาตามแผนของแต่ละช่วง แท่งที่สูงเกินเส้นคือเกินเวลา กดค้างที่แท่งเพื่อดูเวลา',
  'This class': 'คลาสนี้',
  'Earlier classes': 'คลาสก่อนหน้า',

  // Settings
  'I am a': 'ฉันเป็น',
  'A class is still running': 'คลาสยังดำเนินอยู่',
  'Finish or cancel it in Class first, then switch to student.': 'จบหรือยกเลิกคลาสในแท็บคลาสก่อน แล้วค่อยเปลี่ยนเป็นนักศึกษา',
  'Appearance': 'การแสดงผล',
  'System': 'ตามระบบ',
  'Light': 'สว่าง',
  'Dark': 'มืด',
  '{name} theme': 'ธีม{name}',
  'Language': 'ภาษา',
  'Buzz 2 minutes before': 'สั่นก่อน 2 นาที',
  'One soft buzz when a segment has 2 minutes left, two when time is up. A watch paired with your phone buzzes too.':
      'สั่นเบาๆ หนึ่งครั้งเมื่อช่วงเหลือ 2 นาที และสองครั้งเมื่อหมดเวลา นาฬิกาที่จับคู่กับมือถือก็สั่นด้วย',
  'Speech to text': 'แปลงเสียงเป็นข้อความ',
  'Turns lecture recordings into text on this phone with Whisper. Nothing is uploaded.':
      'แปลงเสียงการบรรยายเป็นข้อความบนมือถือด้วย Whisper ไม่มีการอัปโหลด',
  'Notes AI': 'AI ทำโน้ต',
  'On this phone': 'บนมือถือ',
  'Writes summaries and flashcards, and answers questions about your lectures, offline. Everything stays on this phone.':
      'เขียนสรุปและแฟลชการ์ด และตอบคำถามเรื่องการบรรยายแบบออฟไลน์ ทุกอย่างอยู่บนมือถือเครื่องนี้',
  'Fast': 'เร็ว',
  'Quicker. Fine when the lecturer is clear and close.': 'เร็วกว่า เหมาะเมื่อผู้สอนพูดชัดและอยู่ใกล้',
  'Accurate': 'แม่นยำ',
  'Slower, but copes better with distance, noise and accents.': 'ช้ากว่า แต่รับมือกับระยะไกล เสียงรบกวน และสำเนียงได้ดีกว่า',
  'Standard': 'มาตรฐาน',
  'Compact': 'กะทัดรัด',
  'English': 'English',
  'Better notes and answers. Needs a phone with 6 GB of memory or more.': 'โน้ตและคำตอบดีกว่า ต้องใช้มือถือที่มีหน่วยความจำ 6 GB ขึ้นไป',
  'Smaller and quicker, for older phones. Notes are simpler.': 'เล็กและเร็วกว่า สำหรับมือถือรุ่นเก่า โน้ตจะเรียบง่ายกว่า',
  'Pause download': 'พักการดาวน์โหลด',
  'Download {name}': 'ดาวน์โหลด {name}',
  'Delete from phone': 'ลบจากมือถือ',
  'Keep the app open until it finishes.': 'เปิดแอปค้างไว้จนเสร็จ',
  'Not downloaded': 'ยังไม่ได้ดาวน์โหลด',
  'Checking…': 'กำลังตรวจสอบ…',
  'Not set · needed to summarize lectures': 'ยังไม่ได้ตั้ง · ต้องใช้เพื่อสรุปการบรรยาย',
  'Create a key at console.anthropic.com under "API keys", then paste it here. It stays on this phone.':
      'สร้าง key ที่ console.anthropic.com ในหัวข้อ "API keys" แล้ววางที่นี่ key จะอยู่บนมือถือเครื่องนี้เท่านั้น',
  'API key': 'API key',
  'Backup': 'สำรองข้อมูล',
  'Save your notes, plans, timetable, stats and settings to one file, for a new phone or just in case. Your API key is never included.':
      'บันทึกโน้ต แผน ตารางเรียน สถิติ และการตั้งค่าเป็นไฟล์เดียว สำหรับมือถือเครื่องใหม่หรือเผื่อไว้ ไม่รวม API key',
  'Include recordings': 'รวมไฟล์เสียง',
  'About 15 MB per hour of lecture': 'ประมาณ 15 MB ต่อการบรรยายหนึ่งชั่วโมง',
  'Save backup': 'บันทึกไฟล์สำรอง',
  'Backup saved': 'บันทึกไฟล์สำรองแล้ว',
  'Restore a backup?': 'กู้คืนจากไฟล์สำรอง?',
  'Lectures, plans, class history and settings from the backup are added to this phone. Lectures with the same date are replaced. Your timetable comes back switched off; set its code again to turn it on.':
      'การบรรยาย แผน ประวัติคลาส และการตั้งค่าจากไฟล์สำรองจะถูกเพิ่มในมือถือ การบรรยายวันเดียวกันจะถูกแทนที่ ตารางเรียนจะถูกปิดไว้ ตั้งรหัสใหม่เพื่อเปิดใช้',
  'Choose file': 'เลือกไฟล์',
  'Backup restored': 'กู้คืนข้อมูลแล้ว',
  "Couldn't restore that file.": 'กู้คืนจากไฟล์นี้ไม่ได้',
  "Couldn't save the backup: {error}": 'บันทึกไฟล์สำรองไม่ได้: {error}',
  'About': 'เกี่ยวกับ',
  'Licenses': 'สัญญาอนุญาต',
  'Fonts and open-source software in this app': 'ฟอนต์และซอฟต์แวร์โอเพนซอร์สในแอปนี้',

  // Errors from downloads, transcription and the AI
  'No internet connection. Connect to Wi-Fi and try again.': 'ไม่มีอินเทอร์เน็ต เชื่อมต่อ Wi-Fi แล้วลองอีกครั้ง',
  'The download was cut off. Try again to carry on from where it stopped.': 'การดาวน์โหลดถูกตัด ลองอีกครั้งเพื่อทำต่อจากที่ค้างไว้',
  'The connection dropped. Try again to carry on from where it stopped.': 'การเชื่อมต่อหลุด ลองอีกครั้งเพื่อทำต่อจากที่ค้างไว้',
  'The download failed (error {code}). Try again later.': 'ดาวน์โหลดไม่สำเร็จ (ข้อผิดพลาด {code}) ลองใหม่ภายหลัง',
  'This lecture has no recording.': 'การบรรยายนี้ไม่มีไฟล์เสียง',
  'Download the speech model first.': 'ดาวน์โหลดโมเดลถอดเสียงก่อน',
  "Couldn't read the recording. It may be damaged.": 'อ่านไฟล์เสียงไม่ได้ อาจเสียหาย',
  'Transcription failed. Try again, or try the other speech model.': 'ถอดเสียงไม่สำเร็จ ลองอีกครั้งหรือลองโมเดลอื่น',
  "Couldn't hear a question. Try again.": 'ไม่ได้ยินคำถาม ลองอีกครั้ง',
  'There is nothing in this transcript to summarize.': 'ไม่มีเนื้อหาให้สรุปในบันทึกนี้',
  "The AI didn't write any flashcards. Try again.": 'AI ไม่ได้เขียนแฟลชการ์ด ลองอีกครั้ง',
  'The download failed: {error}': 'ดาวน์โหลดไม่สำเร็จ: {error}',
  "The notes AI couldn't start on this phone ({error}). Try the Compact model.": 'AI ทำโน้ตเริ่มบนมือถือนี้ไม่ได้ ({error}) ลองโมเดลแบบกะทัดรัด',
  'No internet connection. Connect and try again.': 'ไม่มีอินเทอร์เน็ต เชื่อมต่อแล้วลองอีกครั้ง',
  'Too many requests. Wait a minute and try again.': 'ส่งคำขอมากเกินไป รอสักครู่แล้วลองอีกครั้ง',

  // Online AI (cloud_ai.dart)
  'Online AI': 'AI ออนไลน์',
  'Other': 'อื่นๆ',
  'Writes summaries online with your own API key. It needs internet, and the transcript is sent to the service you set up.':
      'สรุปโน้ตทางออนไลน์ด้วย API key ของคุณเอง ต้องใช้อินเทอร์เน็ต และบันทึกคำพูดจะถูกส่งไปยังบริการที่คุณตั้งค่าไว้',
  'Writes summaries online with your own API key. It needs internet, and the transcript is sent to {company}.':
      'สรุปโน้ตทางออนไลน์ด้วย API key ของคุณเอง ต้องใช้อินเทอร์เน็ต และบันทึกคำพูดจะถูกส่งไปที่ {company}',
  'OpenRouter, Groq, DeepSeek, Ollama and more': 'OpenRouter, Groq, DeepSeek, Ollama และอื่นๆ',
  'By {company}': 'โดย {company}',
  'Other AI service': 'บริการ AI อื่น',
  '{name} API key': '{name} API key',
  'Saved on this phone · {model}': 'บันทึกบนมือถือแล้ว · {model}',
  'Address': 'ที่อยู่ (URL)',
  'API key (if needed)': 'API key (ถ้ามี)',
  'Model': 'โมเดล',
  'Leave as is unless you want a different model.': 'ไม่ต้องแก้ เว้นแต่อยากใช้โมเดลอื่น',
  'Create a key at platform.openai.com under "API keys", then paste it here. It stays on this phone.':
      'สร้าง key ที่ platform.openai.com ในหัวข้อ "API keys" แล้ววางที่นี่ key จะอยู่บนมือถือเครื่องนี้เท่านั้น',
  'Create a key at aistudio.google.com under "Get API key", then paste it here. It stays on this phone.':
      'สร้าง key ที่ aistudio.google.com ในหัวข้อ "Get API key" แล้ววางที่นี่ key จะอยู่บนมือถือเครื่องนี้เท่านั้น',
  'Any service that works with the OpenAI API, such as OpenRouter, Groq, DeepSeek or Ollama. Enter its address, model and key. They stay on this phone.':
      'บริการใดก็ได้ที่ใช้กับ OpenAI API ได้ เช่น OpenRouter, Groq, DeepSeek หรือ Ollama ใส่ที่อยู่ โมเดล และ key ข้อมูลจะอยู่บนมือถือเครื่องนี้เท่านั้น',
  '{name} is summarizing… this can take a minute.': '{name} กำลังสรุป… อาจใช้เวลาสักครู่',
  'Summarize with {name}': 'สรุปด้วย {name}',
  'Set up the online AI in Settings → Notes AI first.': 'ตั้งค่า AI ออนไลน์ในตั้งค่า → AI ทำโน้ต ก่อน',
  'Add your {name} API key first.': 'ใส่ {name} API key ก่อน',
  '{name} took too long to answer. Try again.': '{name} ตอบช้าเกินไป ลองอีกครั้ง',
  '{name} returned an error ({code}). Try again.': '{name} แจ้งข้อผิดพลาด ({code}) ลองอีกครั้ง',
  'Your {name} API key is not valid. Check it in Settings → Notes AI.': '{name} API key ไม่ถูกต้อง ตรวจสอบในตั้งค่า → AI ทำโน้ต',
  'The model "{model}" was not found. Change it in Settings → Notes AI.': 'ไม่พบโมเดล "{model}" เปลี่ยนได้ในตั้งค่า → AI ทำโน้ต',
  '{name} is busy right now. Try again in a minute.': '{name} ไม่ว่างตอนนี้ ลองอีกครั้งในอีกสักครู่',
  '{name} declined to summarize this recording.': '{name} ไม่สรุปเสียงนี้',
  '{name} returned an empty summary. Try again.': '{name} ส่งสรุปว่างกลับมา ลองอีกครั้ง',

  // Google account and shared locks (account.dart)
  "Account":
      "บัญชี",
  "Lock all your devices together":
      "ล็อกทุกเครื่องพร้อมกัน",
  "Sign in with Google":
      "เข้าสู่ระบบด้วย Google",
  "Sign out":
      "ออกจากระบบ",
  "A lock started on any device signed in to this account locks the others too. If you lose your code, you can get one by email.":
      "เมื่อเริ่มล็อกบนเครื่องใดที่ใช้บัญชีนี้ เครื่องอื่นจะล็อกด้วย ถ้าลืมรหัส ขอรหัสทางอีเมลได้",
  "Sign in with the same account on each device. A lock started on one locks them all. Your lock settings are stored online so your devices can share them.":
      "เข้าสู่ระบบด้วยบัญชีเดียวกันในทุกเครื่อง เมื่อเริ่มล็อกบนเครื่องหนึ่ง ทุกเครื่องจะล็อกด้วย การตั้งค่าล็อกจะถูกเก็บออนไลน์เพื่อให้ทุกเครื่องใช้ร่วมกัน",
  "Forgot it? Email me a code":
      "ลืมรหัส? ส่งรหัสทางอีเมล",
  "Sent to {email}. The code works for {minutes} minutes.":
      "ส่งไปที่ {email} แล้ว รหัสใช้ได้ {minutes} นาที",
  "The code you chose when you started this session, or one emailed to you.":
      "รหัสที่คุณตั้งตอนเริ่มเซสชันนี้ หรือรหัสที่ส่งทางอีเมล",
  "Google didn't sign you in. Try again.":
      "Google ยังไม่ได้ให้เข้าสู่ระบบ ลองอีกครั้ง",
  "Couldn't sign in with Google ({code}).":
      "เข้าสู่ระบบด้วย Google ไม่สำเร็จ ({code})",
  "Add a Google account to this phone (Settings > Accounts), then try again.":
      "เพิ่มบัญชี Google ในโทรศัพท์นี้ก่อน (การตั้งค่า > บัญชี) แล้วลองอีกครั้ง",
  "Sign in with Google in Settings first.":
      "เข้าสู่ระบบด้วย Google ในตั้งค่าก่อน",
  "Pick {email}, the account this app is signed in with.":
      "เลือก {email} ซึ่งเป็นบัญชีที่แอปนี้ใช้อยู่",
  "The app needs permission to send the email. Try again and allow it.":
      "แอปต้องได้รับอนุญาตให้ส่งอีเมล ลองอีกครั้งแล้วกดอนุญาต",
  "Couldn't get permission to send email ({code}).":
      "ขออนุญาตส่งอีเมลไม่สำเร็จ ({code})",
  "No lock is running.":
      "ไม่มีการล็อกอยู่ตอนนี้",
  "Gmail took too long to answer. Try again.":
      "Gmail ตอบช้าเกินไป ลองอีกครั้ง",
  "Gmail refused to send the email. The Gmail API may be switched off for this app.":
      "Gmail ไม่ยอมส่งอีเมล อาจยังไม่ได้เปิด Gmail API ให้แอปนี้",
  "Gmail couldn't send the email ({code}). Try again.":
      "Gmail ส่งอีเมลไม่สำเร็จ ({code}) ลองอีกครั้ง",
  "Your Sati unlock code: {code}":
      "รหัสปลดล็อก Sati ของคุณ: {code}",
  "Your one-time code to end the lock is:\n\n{code}\n\nIt works for {minutes} minutes, on every device signed in to this account. Enter it where you would enter your own code.\n\nIf you didn't ask for this, someone with your phone did. The lock stays on unless the code is entered.":
      "รหัสใช้ครั้งเดียวสำหรับปลดล็อกคือ:\n\n{code}\n\nใช้ได้ {minutes} นาที บนทุกเครื่องที่เข้าสู่ระบบด้วยบัญชีนี้ ใส่รหัสนี้ในช่องเดียวกับรหัสของคุณเอง\n\nถ้าคุณไม่ได้ขอรหัสนี้ แปลว่ามีคนอื่นขอจากมือถือของคุณ การล็อกจะยังคงอยู่จนกว่าจะมีคนใส่รหัส",

  // Email and password sign-in (account_panel.dart)
  "Use email and password":
      "ใช้อีเมลและรหัสผ่าน",
  "Emailed unlock codes need a Google sign-in. With email and password, keep your own code safe.":
      "การส่งรหัสปลดล็อกทางอีเมลต้องเข้าสู่ระบบด้วย Google ถ้าใช้อีเมลและรหัสผ่าน ให้เก็บรหัสของคุณไว้ให้ดี",
  "Create an account":
      "สร้างบัญชี",
  "Sign in with email":
      "เข้าสู่ระบบด้วยอีเมล",
  "Email":
      "อีเมล",
  "Password":
      "รหัสผ่าน",
  "At least 6 characters":
      "อย่างน้อย 6 ตัวอักษร",
  "Confirm password":
      "ยืนยันรหัสผ่าน",
  "Forgot password?":
      "ลืมรหัสผ่าน?",
  "I already have an account":
      "มีบัญชีอยู่แล้ว",
  "New here? Create an account":
      "ยังไม่มีบัญชี? สร้างบัญชี",
  "Create account":
      "สร้างบัญชี",
  "Sign in":
      "เข้าสู่ระบบ",
  "The passwords don't match.":
      "รหัสผ่านไม่ตรงกัน",
  "Enter your email first.":
      "ใส่อีเมลก่อน",
  "Check {email} for a link to choose a new password.":
      "ดูอีเมล {email} เพื่อกดลิงก์ตั้งรหัสผ่านใหม่",
  "That email address doesn't look right.":
      "อีเมลนี้ดูไม่ถูกต้อง",
  "There's already an account with this email. Sign in instead.":
      "มีบัญชีที่ใช้อีเมลนี้อยู่แล้ว ให้เข้าสู่ระบบแทน",
  "Choose a password of at least 6 characters.":
      "ตั้งรหัสผ่านอย่างน้อย 6 ตัวอักษร",
  "Wrong email or password.":
      "อีเมลหรือรหัสผ่านไม่ถูกต้อง",
  "Too many tries. Wait a few minutes and try again.":
      "ลองหลายครั้งเกินไป รอสักครู่แล้วลองอีกครั้ง",
  "Email sign-in isn't switched on for this app yet.":
      "แอปนี้ยังไม่ได้เปิดการเข้าสู่ระบบด้วยอีเมล",
  "Couldn't sign in ({code}).":
      "เข้าสู่ระบบไม่สำเร็จ ({code})",

  // Durations
  '{n} min': '{n} นาที',
  '{n} h': '{n} ชม.',
  '{h} h {m} min': '{h} ชม. {m} นาที',
  '{n} s': '{n} วินาที',
};

/// Every English text that has a Thai version, for the test that checks nothing is missing.
@visibleForTesting
Set<String> get thaiKeys => _th.keys.toSet();

/// Whether the app is showing Thai right now.
bool get isThai => AppSettings.instance.isThai;

extension Tr on String {
  /// This text in the app's language.
  String get tr => isThai ? (_th[this] ?? this) : this;

  /// This template in the app's language, with {name} placeholders filled from [args].
  String trf(Map<String, Object?> args) {
    var out = tr;
    args.forEach((key, value) => out = out.replaceAll('{$key}', '$value'));
    return out;
  }
}
