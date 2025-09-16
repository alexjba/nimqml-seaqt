import locks
import macros
import strutils
import sequtils
import tables
import typetraits

import os
## NimQml aims to provide binding to the QML for the Nim programming language

template debugMsg(message: string) =
  discard
  # echo "NimQml: ", message

template debugMsg(typeName: string, procName: string) =
  when defined(debug):
    debugMsg(typeName & ": " & procName)

include "nimqml/private/nimqmlmacros.nim"
include "nimqml/private/dotherside.nim"
include "nimqml/private/nimqmltypes.nim"
include "nimqml/private/constructors.nim"
include "nimqml/private/qvariant.nim"
include "nimqml/private/lambdainvoker.nim"
include "nimqml/private/qmetaobjectconnection.nim"
include "nimqml/private/qmetaobject.nim"
include "nimqml/private/qobject.nim"
include "nimqml/private/qqmlapplicationengine.nim"
include "nimqml/private/qcoreapplication.nim"
include "nimqml/private/qguiapplication.nim"
include "nimqml/private/qapplication.nim"
include "nimqml/private/qurl.nim"
include "nimqml/private/qquickview.nim"
include "nimqml/private/qhashintbytearray.nim"
include "nimqml/private/qmodelindex.nim"
include "nimqml/private/qabstractitemmodel.nim"
include "nimqml/private/qabstractlistmodel.nim"
include "nimqml/private/qabstracttablemodel.nim"
include "nimqml/private/qresource.nim"
include "nimqml/private/qdeclarative.nim"
include "nimqml/private/qsettings.nim"
include "nimqml/private/status/statusevent.nim"
include "nimqml/private/status/statusosnotification.nim"
include "nimqml/private/status/statuskeychainmanager.nim"
include "nimqml/private/singleinstance.nim"
include "nimqml/private/qtimer.nim"

proc signal_handler*(receiver: pointer, signal: cstring, slot: cstring) =
  var dosqobj = cast[DosQObject](receiver)
  if(dosqobj.isNil == false):
    dos_signal(receiver, signal, slot)

proc save_byte_image_to_file*(imagePath: string, tmpDir: string): string =
  discard existsOrCreateDir(tmpDir)
  let imagePath = dos_save_byte_image_to_file(imagePath.cstring, tmpDir.cstring)
  defer: dos_chararray_delete(imagePath)
  result = $(imagePath)

proc plain_text*(htmlString: string): string =
  let plainText = dos_plain_text(htmlString.cstring)
  defer: dos_chararray_delete(plainText)
  result = $(plainText)

proc escape_html*(input: string): string =
  let escapedHtml = dos_escape_html(input.cstring)
  defer: dos_chararray_delete(escapedHtml)
  result = $(escapedHtml)


proc url_fromUserInput*(input: string): string =
  let urlStr = dos_qurl_fromUserInput(input.cstring)
  defer: dos_chararray_delete(urlStr)
  result = $(urlStr)

proc url_host*(host: string): string =
  let qurlHost = dos_qurl_host(host.cstring)
  defer: dos_chararray_delete(qurlHost)
  result = $(qurlHost)

proc url_replaceHostAndAddPath*(url: string, newHost: string, protocol: string = "", pathPrefix: string = ""): string =
  let newUrl = dos_qurl_replaceHostAndAddPath(url.cstring, protocol.cstring, newHost.cstring, pathPrefix.cstring)
  defer: dos_chararray_delete(newUrl)
  result = $(newUrl)

proc url_toLocalFile*(fileUrl: string): string =
  let filePath = dos_to_local_file(fileUrl.cstring)
  defer: dos_chararray_delete(filePath)
  result = $(filePath)

proc url_fromLocalFile*(filePath: string): string =
  let url = dos_from_local_file(filePath.cstring)
  defer: dos_chararray_delete(url)
  result = $(url)


proc setTranslationPackage*(self: QQmlApplicationEngine, packagePath: string, shouldRetranslate: bool = true) =
  dos_qguiapplication_load_translation(self.vptr, packagePath.cstring, shouldRetranslate)

proc app_isActive*(engine: QQmlApplicationEngine): bool =
  result = dos_app_is_active(engine.vptr)

proc app_makeItActive*(engine: QQmlApplicationEngine) =
  dos_app_make_it_active(engine.vptr)

proc installSelfSignedCertificate*(certificate: string) =
  dos_add_self_signed_certificate(certificate.cstring)

proc tryEnableThreadedRenderer*() =
  dos_qguiapplication_try_enable_threaded_renderer()

proc icon*(application: QGuiApplication, filename: string) =
  dos_qguiapplication_icon(filename.cstring)

proc installMessageHandler*(handler: DosMessageHandler) =
  dos_installMessageHandler(handler)

proc installEventFilter*(application: QGuiApplication, event: StatusEvent) =
  dos_qguiapplication_installEventFilter(event.vptr)
