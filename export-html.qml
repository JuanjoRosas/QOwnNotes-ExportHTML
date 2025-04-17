import QtQml 2.2
import QOwnNotesTypes 1.0
import com.qownnotes.noteapi 1.0

Script {
    property string separator;

    property variant settingsVariables: [
        {
            "identifier": "separator",
            "name": "Separador de ruta",
            "description": "",
            "type": "string",
            "default": "/",
        }
    ]

    function init() {
        script.registerCustomAction("customExportHTML", "export HTML", "export HTML", "", true)
    }

    function relativePath(folder1, folder2){
        var folder1Array = folder1.split(separator);
        var folder2Array = folder2.split(separator);
        for (var i = 0; i < folder2Array.length; i++) {
            if (i < folder1Array.length) {
                if (folder1Array[i] != folder2Array[i]) break;
            }else{
                break;
            }
        }
        folder1Array = ["."].concat(folder1Array.slice(i).map((x)=>".."));
        folder2Array = folder2Array.slice(i);
        var outputString = concatenateArray(folder1Array.concat(folder2Array), separator);
        return outputString;
    }

    function concatenateArray(myArray,separator,fromIndex=null,toIndex=null){
        fromIndex = fromIndex == null? 0 : fromIndex;
        toIndex = toIndex == null? myArray.length - 1 : toIndex;
        var outputString = "";
        for (var i = fromIndex; i <= toIndex; i++) {
            outputString += i == fromIndex? myArray[i] : separator + myArray[i]
        }
        return outputString;
    }

    function customActionInvoked(action) {
        if (action == "customExportHTML") {
            //Current Note
            var curNote = script.currentNote();

            //Select export file and folder
            var exportFilePath = script.getSaveFileName(
                "Seleccione el archivo HTML para guardar",
                curNote.name + ".html",
                "HTML (*.html)",
            );
            var exportFolderPath = concatenateArray(exportFilePath.split(separator).slice(0,-1),separator);

            //Select new media folder path & calculate relative path
            var exportMediaFilePath = script.getSaveFileName(
                "Seleccione la nueva carpeta multimedia",
                exportFolderPath + separator + "undefined"
            );
            var exportMediaFolderPath = concatenateArray(exportMediaFilePath.split(separator).slice(0,-1),separator);
            var mediaFolderRelativePath = relativePath(exportFolderPath,exportMediaFolderPath)

            //Select new attachments folder path & calculate relative path
            var exportAttachmentFilePath = script.getSaveFileName(
                "Seleccione la nueva carpeta de adjuntos",
                exportFolderPath + separator + "undefined"
            );
            var exportAttachmentFolderPath = concatenateArray(exportAttachmentFilePath.split(separator).slice(0,-1),separator);
            var attachmentFolderRelativePath = relativePath(exportFolderPath,exportAttachmentFolderPath)

            //TODO: Exportar notas, adjuntos y multimedia.

            //Process done information message
            script.informationMessageBox(
                "Proceso terminado.\n* Ruta archivo: "+ exportFilePath +"\n* Ruta multimedia: " + mediaFolderRelativePath + "\n* Ruta adjuntos: "+ attachmentFolderRelativePath,
                "Proceso terminado"
            )
        }
    }
}
