# This is Titanium to JavaScript transpiller - codename Athena
# It was written by André Pereira (AndrewNation) for converting
# Titanium code to JavaScript. It's the script used in Gusleothew
# playground and the Andrew Toolchain interpreter.

JavaScriptOutput = []
code = []

rules = {
    constantDeclaration: /DEF .*[A-Za-z_] = "?.*[A-Za-z0-9\(\)]?"?/
    printCommand: /print\("?.*[\[\]0-9A-Z a-z!,_ ?:><=!]?"?\)/g
    variableDeclaration: /DECL .*[A-Za-z_] = "?.*[A-Za-z0-9\+]?"?/gm
}

titanium = {
    constKeyword: "DEF"
    printKeyword: "print("
    varKeyword: "DECL"
}

javascript = {
    constKeyword: "const"
    printKeyword: "console.log("
    varKeyword: "let"
}

parseVariables = (statement) ->
    return statement.replace(titanium.varKeyword, javascript.varKeyword)

parsePrint = (statement) ->
    return statement.replace(titanium.printKeyword, javascript.printKeyword)

parseConstants = (statement) ->
    return statement.replace(titanium.constKeyword, javascript.constKeyword)

parseLine = (line) ->
    if line.match(rules.constantDeclaration)
        return parseConstants(line)
    
    if line.match(rules.variableDeclaration)
        return parseVariables(line)
    
    if line.match(rules.printCommand)
        return parsePrint(line)
    
    throw "[error] issues have been found in your Titanium code. Please verify it with Titanium CLI or Gusleothew playground"

parseTitaniumToJavaScript = (code) ->
    for line in code
        JavaScriptOutput.push parseLine(line)

code.push "DECL x = 19"
code.push "print(\"Titanium to JS transpiller written in CoffeeScript\")"

JavaScriptOutput.push "//Converted from Titanium to JavaScript with Athena"
JavaScriptOutput.push "function main() {"
parseTitaniumToJavaScript(code)
JavaScriptOutput.push "}\n\nmain();"

console.log JavaScriptOutput