import fs from 'node:fs/promises';
import path from 'node:path';

const GENERATED_HEADER = '# This file is generated. Do not edit manually.';

function normalizeLineEndings(text) {
  return text.replace(/\r\n/g, '\n');
}

function ensureTrailingNewline(text) {
  return text.endsWith('\n') ? text : `${text}\n`;
}

function indentValues(valuesText) {
  const normalizedValues = normalizeLineEndings(valuesText);

  if (normalizedValues.length === 0) {
    return '';
  }

  const hasTrailingNewline = normalizedValues.endsWith('\n');
  const body = hasTrailingNewline ? normalizedValues.slice(0, -1) : normalizedValues;

  if (body.length === 0) {
    return '';
  }

  const indentedBody = body.split('\n').map((line) => `    ${line}`).join('\n');
  return hasTrailingNewline ? `${indentedBody}\n` : indentedBody;
}

function normalizeWhitespaceOnlyLines(text) {
  return text
    .split('\n')
    .map((line) => (/^\s+$/.test(line) ? '' : line))
    .join('\n');
}

async function createHelmYaml(templatePath, valuesPath, outputPath) {
  const [templateContent, valuesContent] = await Promise.all([
    fs.readFile(templatePath, 'utf8'),
    fs.readFile(valuesPath, 'utf8'),
  ]);

  const normalizedTemplate = ensureTrailingNewline(normalizeLineEndings(templateContent));
  const indentedValues = indentValues(valuesContent);
  const outputContent = ensureTrailingNewline(
    normalizeWhitespaceOnlyLines(
      `${GENERATED_HEADER}\n${normalizedTemplate}${indentedValues}`,
    ),
  );
  const temporaryOutputPath = `${outputPath}.tmp`;

  await fs.writeFile(temporaryOutputPath, outputContent, 'utf8');
  await fs.rename(temporaryOutputPath, outputPath);
}

function getUsage(scriptPath) {
  return `Usage: node ${path.basename(scriptPath)} <template.yaml> <values.yaml> <output.yaml>`;
}

async function main() {
  const [, scriptPath, templateArg, valuesArg, outputArg] = process.argv;

  if (!templateArg || !valuesArg || !outputArg) {
    console.error(getUsage(scriptPath || 'create-helm-using-yaml.js'));
    process.exitCode = 1;
    return;
  }

  try {
    await createHelmYaml(templateArg, valuesArg, outputArg);
  } catch (error) {
    console.error(error instanceof Error ? error.message : String(error));
    process.exitCode = 1;
  }
}

void main();
