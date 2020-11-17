#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2020 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2017 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See docs/COPYRIGHT.rdoc for more details.
#++

require 'spec_helper'
require_relative './expected_markdown'

describe OpenProject::TextFormatting,
         'lists' do
  include_context 'expected markdown modules'

  context 'ordered lists' do
    it_behaves_like 'format_text produces' do
      let(:raw) do
        <<~RAW
          1. First item
          2. Second item
          3. Third item
          5. Item out of line
        RAW
      end

      let(:expected) do
        <<~EXPECTED
          <ol class="op-uc-list">
            <li class="op-uc-list--item">First item</li>
            <li class="op-uc-list--item">Second item</li>
            <li class="op-uc-list--item">Third item</li>
            <li class="op-uc-list--item">Item out of line</li>
          </ol>
        EXPECTED
      end
    end
  end

  context 'unordered lists' do
    it_behaves_like 'format_text produces' do
      let(:raw) do
        <<~RAW
          * First item
          * Second item
            * First subitem of second item
          * Third item
        RAW
      end

      let(:expected) do
        <<~EXPECTED
          <ul class="op-uc-list">
            <li class="op-uc-list--item">First item</li>
            <li class="op-uc-list--item">Second item
            <ul class="op-uc-list">
              <li class="op-uc-list--item">First subitem of second item</li>
            </ul>
            </li>
            <li class="op-uc-list--item">Third item</li>
          </ul>
        EXPECTED
      end
    end
  end

  context 'todo list' do
    context 'in a table' do
      it_behaves_like 'format_text produces' do
        let(:raw) do
          <<~RAW
            <table>
              <tbody>
                <tr>
                  <td>
                    <ul class="todo-list">
                      <li>
                        <code class='op-uc-code'>
                          <label class="todo-list__label"><input type="checkbox" disabled="disabled">
                            <span class="todo-list__label__description">asdf</span>
                          </label>
                        </code>
                      </li>
                    </ul>
                  </td>
                  <td>
                    <ul class="todo-list">
                      <li>
                        <a class="op-uc-link" href="https://example.com/">
                          <label class="todo-list__label">
                            <input type="checkbox" disabled="disabled">
                            <span class="todo-list__label__description">asdfasd</span>
                          </label>
                          <span class="todo-list__label__description"> asdf</span>
                        </a>
                      </li>
                    </ul>
                  </td>
                  <td>
                    <ul class="todo-list">
                      <li>
                        <label class="todo-list__label">
                          <input type="checkbox" disabled="disabled">
                          <span
                            class="todo-list__label__description">asdfasdf</span>
                          </label>
                        </li>
                    </ul>
                  </td>
                </tr>
                <tr>
                  <td>
                    <ul class="todo-list">
                      <li>
                        <label class="todo-list__label">
                          <input type="checkbox" disabled="disabled">
                        </label>
                      </li>
                    </ul>
                  </td>
                  <td>
                    <ul class="todo-list">
                      <li>
                        <label class="todo-list__label">
                          <strong>
                            <input type="checkbox" disabled="disabled">
                          </strong>
                          <span
                            class="todo-list__label__description">
                            <strong>asdf</strong>
                          </span>
                        </label>
                      </li>
                    </ul>
                  </td>
                  <td>
                    <ul class="todo-list">
                      <li>
                        <label class="todo-list__label">
                          <input type="checkbox" disabled="disabled"></label>
                        </li>
                    </ul>
                  </td>
                </tr>
              </tbody>
            </table>
          RAW
        end

        let(:expected) do
          <<~EXPECTED
            <figure class="op-uc-figure"> 
              <table class="op-uc-table op-uc-figure--content">
                <tbody>
                  <tr class="op-uc-table--row">
                    <td class="op-uc-table--cell">
                      <ul class="task-list op-uc-list">
                        <li class="task-list-item op-uc-list--item">
                          <input type="checkbox" class="task-list-item-checkbox" disabled>
                          <code class='op-uc-code'>
                            <span>asdf</span>
                          </code>
                        </li>
                      </ul>
                    </td>
                    <td class="op-uc-table--cell">
                      <ul class="task-list op-uc-list">
                        <li class="task-list-item op-uc-list--item">
                          <input type="checkbox" class="task-list-item-checkbox" disabled>
                          <a class="op-uc-link" href="https://example.com/" rel="noopener noreferrer">
                            <span>asdfasd</span>
                            <span> asdf</span>
                          </a>
                        </li>
                      </ul>
                    </td>
                    <td class="op-uc-table--cell">
                      <ul class="task-list op-uc-list">
                        <li class="task-list-item op-uc-list--item">
                          <input type="checkbox" class="task-list-item-checkbox" disabled>
                          <span>asdfasdf</span>
                        </li>
                      </ul>
                    </td>
                  </tr>
                  <tr class="op-uc-table--row">
                    <td class="op-uc-table--cell">
                      <ul class="task-list op-uc-list">
                        <li class="task-list-item op-uc-list--item">
                          <input type="checkbox" class="task-list-item-checkbox" disabled>
                        </li>
                      </ul>
                    </td>
                    <td class="op-uc-table--cell">
                      <ul class="task-list op-uc-list">
                        <li class="task-list-item op-uc-list--item">
                          <input type="checkbox" class="task-list-item-checkbox" disabled>
                          <strong></strong>
                          <span><strong>asdf</strong></span>
                        </li>
                      </ul>
                    </td>
                    <td class="op-uc-table--cell">
                      <ul class="task-list op-uc-list">
                        <li class="task-list-item op-uc-list--item">
                          <input type="checkbox" class="task-list-item-checkbox" disabled>
                        </li>
                      </ul>
                    </td>
                  </tr>
                </tbody>
              </table>
            </figure>
          EXPECTED
        end
      end
    end

    context 'in a table and with a link on second place' do
      it_behaves_like 'format_text produces' do
        let(:raw) do
          <<~RAW
            <table>
              <tbody>
                <tr>
                  <td>asdf</td>
                  <td>asdfasdf</td>
                </tr>
                <tr>
                  <td>
                    <ul class="todo-list">
                      <li>
                        <label class="todo-list__label"><input type="checkbox" disabled="disabled">
                          <span class="todo-list__label__description">asdfasdfasdf </span>
                        </label>
                        <a class="op-uc-link" href="https://example.com/">
                          <label class="todo-list__label">
                            <span class="todo-list__label__description">foobar</span>
                          </label>
                        </a>
                      </li>
                    </ul>
                  </td>
                  <td></td>
                </tr>
              </tbody>
            </table>
          RAW
        end

        let(:expected) do
          <<~EXPECTED
            <figure class="op-uc-figure"> 
              <table class="op-uc-table op-uc-figure--content">
                <tbody>
                  <tr class="op-uc-table--row">
                    <td class="op-uc-table--cell">asdf</td>
                    <td class="op-uc-table--cell">asdfasdf</td>
                  </tr>
                  <tr class="op-uc-table--row">
                    <td class="op-uc-table--cell">
                      <ul class="task-list op-uc-list">
                        <li class="task-list-item op-uc-list--item">
                          <input type="checkbox" class="task-list-item-checkbox" disabled>
                          <span>asdfasdfasdf </span>
                          <a class="op-uc-link" href="https://example.com/" rel="noopener noreferrer">
                            <span>foobar</span>
                          </a>
                        </li>
                      </ul>
                    </td>
                    <td class="op-uc-table--cell"></td>
                  </tr>
                </tbody>
              </table>
            </figure>
          EXPECTED
        end
      end
    end
  end
end
