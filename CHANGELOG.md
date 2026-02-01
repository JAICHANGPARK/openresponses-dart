# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-02-01

### Added

- Initial release of the Dart client for Open Responses API

## [Unreleased]
- Support for creating chat completions via OpenAI-compatible API
- Streaming support with Server-Sent Events (SSE)
- Function calling support with tools
- Comprehensive type system for requests, responses, and events
- Dot shorthand syntax examples (Dart 3.10+)

### Features

- **Client**: Simple HTTP client for API interactions
- **StreamingClient**: Real-time streaming with SSE
- **Types**: Full type safety for all API entities
  - `Input` with support for text or items
  - `Item` types: `MessageItem`, `FunctionCallItem`, etc.
  - Content types: `InputContent`, `OutputContent`
  - Enums: `MessageRole`, `ToolChoice`, `ImageDetail`, etc.
- **Tools**: Function tool creation with `FunctionTool` builder

### Dependencies

- `http: ^1.6.0` - HTTP client
- `json_annotation: ^4.10.0` - JSON serialization
- `freezed_annotation: ^3.1.0` - Immutable data classes
